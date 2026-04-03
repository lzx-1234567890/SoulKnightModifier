#include "save_game_processor.h"
#include <QFile>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonParseError>
#include <QRegularExpression>
#include <QDebug>

#include "file_processor.h"
#include "json_processor.h"
#include "lite_des.h"

// 初始化常量
const QByteArray SaveGameProcessor::DES_IV = QByteArray::fromRawData("\x41\x68\x62\x6f\x6f\x6c\x0\x0", 8);
const QByteArray SaveGameProcessor::XOR_KEY = QByteArray::fromRawData(
    "\x73\x6c\x63\x7a\x7d\x67\x75\x63\x7f\x57\x6d\x6c\x6b\x4a\x5f", 15);

const QByteArray SaveGameProcessor::DES_IMABO_KEY = QByteArray::fromRawData("\x69\x61\x6d\x62\x6f\x0\x0\x0", 8);
const QByteArray SaveGameProcessor::DES_CRST1_KEY = QByteArray::fromRawData("\x63\x72\x73\x74\x31\x0\x0\x0", 8);

//解析函数
QJsonObject SaveGameProcessor::processToJson(const QString &filePath, const int type) {
    const QFileInfo fileInfo(filePath);
    const QString fileName = fileInfo.fileName();

    //读取
    QByteArray rawData = FileProcessor::m_instance->readFileByByte(filePath);
    if(rawData.size() == 0) return QJsonObject();

    //解析
    if(fileName.endsWith(".data")) rawData = decryptData(rawData, type);
    else if(fileName.endsWith(".decrypted")) {
        QJsonParseError error;
        QJsonDocument doc = QJsonDocument::fromJson(rawData, &error);
        if (error.error != QJsonParseError::NoError) return QJsonObject();
        rawData = doc.toJson(QJsonDocument::Compact);
    }

    if(fileName.endsWith(".data") || fileName.endsWith(".decrypted")) {
        QJsonParseError error;
        QJsonDocument doc = QJsonDocument::fromJson(rawData, &error);
        if (error.error != QJsonParseError::NoError) return QJsonObject();
        return doc.object();
    }else if(fileName.endsWith(".xml")){
        QJsonObject doc = JsonProcessor::convertXmlToJson(QString::fromUtf8(rawData));
        if(doc.size() == 0) return QJsonObject();
        return doc;
    }
    return QJsonObject();
}

//解密路由
QByteArray SaveGameProcessor::decryptData(const QByteArray &data, const int type) {
    // 0:XOR 解密
    // 1:DES 解密 (iambo 密钥)
    // 2:DES 解密 (crst1 密钥)
    // 3:XML 明文

    if(type == XOR) {
        QByteArray decryptedBytes = xorCipher(data);
        return decryptedBytes;
    }else if(type == DES_IMABO) {
        QByteArray key = DES_IMABO_KEY;
        return decryptDES(data, key);
    }else if(type == DES_CRST1) {
        QByteArray key = DES_CRST1_KEY;
        return decryptDES(data, key);
    }else if(type == XML) {
        return formatXML(QString::fromUtf8(data)).toUtf8();
    }
    return data;
}

//DES解密
QByteArray SaveGameProcessor::decryptDES(const QByteArray &base64Data, const QByteArray &key) {
    QByteArray cipherBytes = QByteArray::fromBase64(base64Data);
    QByteArray plainTextBytes = LiteDES::decryptCBC(cipherBytes, key, DES_IV);
    return plainTextBytes;
}

//导出加密函数
QByteArray SaveGameProcessor::processFromJson(const QJsonObject &jsonObj, const int type) {
    if (jsonObj.isEmpty()) return QByteArray();
    QJsonDocument doc(jsonObj);
    QByteArray plainBytes = doc.toJson(QJsonDocument::Compact);
    return encryptData(plainBytes, type);
}

//加密路由
QByteArray SaveGameProcessor::encryptData(const QByteArray &plainBytes, const int type) {
    if (type == XOR) {
        return xorCipher(plainBytes);
    } else if (type == DES_IMABO) {
        QByteArray key = DES_IMABO_KEY;
        return encryptDES(plainBytes, key);
    } else if (type == DES_CRST1) {
        QByteArray key = DES_CRST1_KEY;
        return encryptDES(plainBytes, key);
    } else if (type == XML) {
        return plainBytes;
    }
    return plainBytes;
}

//DES加密
QByteArray SaveGameProcessor::encryptDES(const QByteArray &plainBytes, const QByteArray &key) {
    QByteArray cipherBytes = LiteDES::encryptCBC(plainBytes, key, DES_IV);
    return cipherBytes.toBase64();
}

//XOR解密加密
QByteArray SaveGameProcessor::xorCipher(const QByteArray &data) {
    QByteArray output = data;
    int keyLen = XOR_KEY.size();
    for (int i = 0; i < data.size(); ++i) {
        output[i] = output[i] ^ XOR_KEY[i % keyLen];
    }
    return output;
}

//XML格式化
QString SaveGameProcessor::formatXML(const QString &xmlString) {
    QRegularExpression regex("(<.*?/>|<.*?</.*?>)");
    QRegularExpressionMatchIterator i = regex.globalMatch(xmlString);

    QStringList attrs;
    while (i.hasNext()) {
        QRegularExpressionMatch match = i.next();
        attrs.append(match.captured(1));
    }

    attrs.sort(Qt::CaseInsensitive);

    QString finalXml = "<?xml version='1.0' encoding='utf-8' standalone='yes' ?>\n<map>";
    for (const QString &attr : attrs) {
        finalXml += "\n    " + attr;
    }
    finalXml += "\n</map>";

    return finalXml;
}

bool SaveGameProcessor::xorCipherTool(const QString &path, const QString &path2) {
    QByteArray rawData = FileProcessor::m_instance->readFileByByte(path);
    if(rawData.size() == 0) return false;
    QByteArray newData = xorCipher(rawData);
    return FileProcessor::m_instance->writeFileByByte(path2, newData);
}

bool SaveGameProcessor::decryptDESTool(const QString &path, const QString &path2, const int type) {
    //读取
    QByteArray rawData = FileProcessor::m_instance->readFileByByte(path);
    if(rawData.size() == 0) return false;

    //解密
    QByteArray key;
    if(type == 0) {
        key = DES_IMABO_KEY;
    }else if(type == 1) {
        key = DES_CRST1_KEY;
    }
    QByteArray newData = decryptDES(rawData, key);

    //格式化
    QByteArray jsonBytes = newData;
    QJsonParseError parseError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(jsonBytes, &parseError);
    if (parseError.error != QJsonParseError::NoError) return false;
    QByteArray formattedBytes = jsonDoc.toJson(QJsonDocument::Indented);
    return FileProcessor::m_instance->writeFileByString(path2, QString::fromUtf8(formattedBytes));
}

bool SaveGameProcessor::encryptDESTool(const QString &path, const QString &path2, const int type) {
    //读取
    QByteArray rawData = FileProcessor::m_instance->readFileByByte(path);
    if(rawData.size() == 0) return false;

    //格式化
    QJsonParseError parseError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(rawData, &parseError);
    if (parseError.error != QJsonParseError::NoError) return false;
    QByteArray formattedBytes = jsonDoc.toJson(QJsonDocument::Compact);

    //加密
    QByteArray key;
    if(type == 0) {
        key = DES_IMABO_KEY;
    }else if(type == 1) {
        key = DES_CRST1_KEY;
    }
    QByteArray newData = encryptDES(formattedBytes, key);
    return FileProcessor::m_instance->writeFileByByte(path2, newData);
}

bool SaveGameProcessor::formatXMLTool(const QString &path, const QString &path2) {
    QString rawData = FileProcessor::m_instance->readFileByString(path);
    if(rawData.size() == 0) return false;
    QString newData = formatXML(rawData);
    return FileProcessor::m_instance->writeFileByString(path2, newData);
}