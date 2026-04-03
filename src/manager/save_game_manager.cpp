#include "save_game_manager.h"
#include "src/utils/file_processor.h"
#include "src/utils/save_game_processor.h"
#include "src/utils/json_processor.h"
#include <QFileInfo>

SaveGameManager* SaveGameManager::m_instance = nullptr;

bool SaveGameManager::parseSaveGame(const QString &filePath) {
    const QFileInfo fileInfo(filePath);
    const QString fileName = fileInfo.fileName();
    int fileType, decryptType;
    if(fileName.contains("game")) {
        fileType = 0;
        decryptType = SaveGameProcessor::XOR;
    }else if(fileName.contains("item_data")) {
        fileType = 1;
        decryptType = SaveGameProcessor::DES_IMABO;
    }else if(fileName.contains("season_data")) {
        fileType = 2;
        decryptType = SaveGameProcessor::DES_IMABO;
    }else if(fileName.contains("task")) {
        fileType = 3;
        decryptType = SaveGameProcessor::DES_IMABO;
    }else if(fileName.contains("setting")) {
        fileType = 4;
        decryptType = SaveGameProcessor::DES_IMABO;
    }else if(fileName.contains("statistic")) {
        fileType = 5;
        decryptType = SaveGameProcessor::DES_CRST1;
    }else if(fileName.contains("weapon_evolution")) {
        fileType = 6;
        decryptType = SaveGameProcessor::DES_IMABO;
    }else if(fileName.contains("pvp_data")) {
        fileType = 7;
        decryptType = SaveGameProcessor::DES_IMABO;
    }else if(fileName.endsWith(".xml")) {
        fileType = 50;
        decryptType = SaveGameProcessor::XML;
    }else {
        fileType = 0;
        decryptType = SaveGameProcessor::XML;
    }
    QJsonObject jsonData = SaveGameProcessor::processToJson(filePath, decryptType);
    if(jsonData.size() == 0) return false;
    SaveFileInfo save(filePath, fileName, fileType, decryptType);
    save.originalContent = jsonData;
    save.modifiedContent = jsonData;
    SaveGameManager::m_instance->append(save);
    return true;
}

SaveListModel* SaveGameManager::getSaveListModel() {
    return m_saveListModel;
}

SaveFileInfo SaveGameManager::get(const int index) {
    return m_saveListModel->get(index);
}

void SaveGameManager::append(const SaveFileInfo &save) {
    if(m_saveListModel) {
        m_saveListModel->append(save);
    }
}

void SaveGameManager::remove(const int index) {
    if(m_saveListModel) {
        m_saveListModel->remove(index);
    }
}

void SaveGameManager::setValue(const int index, const QString &path, const QVariant &obj) {
    if (path.isEmpty()) return;
    QStringList steps = path.split('.');
    m_saveListModel->updateModifiedContent(index, JsonProcessor::setValue(get(index).modifiedContent, steps, obj));
}

void SaveGameManager::insertDirty(const int index, const QString &key, const QVariant &val) {
    m_saveListModel->insertDirty(index, key, val);
}

void SaveGameManager::removeDirty(const int index, const QString &key) {
    m_saveListModel->removeDirty(index, key);
}

int SaveGameManager::getDirtyCount(const int index) {
    return m_saveListModel->getDirtyCount(index);
}

bool SaveGameManager::exportEncryptedFile(const QString &filePath, const int index) {
    if(get(index).fileType == 50) {
        return FileProcessor::m_instance->writeFileByString(filePath, SaveGameProcessor::formatXML(JsonProcessor::convertJsonToXmlTags(get(index).originalContent)));
    }else {
        QJsonDocument doc(get(index).originalContent);
        QByteArray bytes = doc.toJson(QJsonDocument::Compact);
        return FileProcessor::m_instance->writeFileByByte(filePath, SaveGameProcessor::encryptData(bytes, get(index).decryptType));
    }
    return false;
}

bool SaveGameManager::exportDecryptedFile(const QString &filePath, const int index) {
    if(get(index).fileType == 50) {
        return FileProcessor::m_instance->writeFileByString(filePath, SaveGameProcessor::formatXML(JsonProcessor::convertJsonToXmlTags(get(index).originalContent)));
    }else {
        QJsonDocument doc(get(index).originalContent);
        QByteArray bytes = doc.toJson(QJsonDocument::Indented);
        QString jsonString = QString::fromUtf8(bytes);
        return FileProcessor::m_instance->writeFileByString(filePath, jsonString);
    }
    return false;
}

bool SaveGameManager::resetFile(const int index) {
    return m_saveListModel->reset(index);
}

bool SaveGameManager::saveFile(const QJsonObject &data, const int index) {
    return m_saveListModel->save(data, index);
}