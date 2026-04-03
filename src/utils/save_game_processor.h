#ifndef SAVEGAMEPROCESSOR_H
#define SAVEGAMEPROCESSOR_H

#include <QString>
#include <QObject>
#include <QByteArray>
#include <QJsonObject>
#include <qqmlintegration.h>

class SaveGameProcessor: public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit SaveGameProcessor(QObject *parent = nullptr) : QObject(parent) {}

    // 核心对外接口：传入文件路径，返回解析好的 JSON 对象
    static QJsonObject processToJson(const QString &filePath, const int type);
    static QByteArray processFromJson(const QJsonObject &jsonObj, const int type);

    //static QString decryptData(const QByteArray &data, const int type);
    static QByteArray decryptData(const QByteArray &data, const int type);
    static QByteArray encryptData(const QByteArray &plainBytes, const int type);

    static QString formatXML(const QString &xmlString);

    //解密方式枚举
    enum DecrypteType {
        XOR = 0,
        DES_IMABO,
        DES_CRST1,
        XML
    };

    //对qml使用解密加密工具
    Q_INVOKABLE bool xorCipherTool(const QString &path, const QString &path2);
    Q_INVOKABLE bool decryptDESTool(const QString &path, const QString &path2, const int type);
    Q_INVOKABLE bool encryptDESTool(const QString &path, const QString &path2, const int type);
    Q_INVOKABLE bool formatXMLTool(const QString &path, const QString &path2);

private:
    // 核心算法
    //static QByteArray xorCipher(const QByteArray &data);
    //static QString decryptDES(const QByteArray &base64Data, const QByteArray &key);
    //static QByteArray encryptDES(const QByteArray &plainBytes, const QByteArray &key);

    static QByteArray xorCipher(const QByteArray &data);
    static QByteArray decryptDES(const QByteArray &base64Data, const QByteArray &key);
    static QByteArray encryptDES(const QByteArray &plainBytes, const QByteArray &key);

    // 预定义的密钥常量
    static const QByteArray DES_IV;
    static const QByteArray XOR_KEY;

    static const QByteArray DES_IMABO_KEY;
    static const QByteArray DES_CRST1_KEY;
};

#endif // SAVEGAMEPROCESSOR_H