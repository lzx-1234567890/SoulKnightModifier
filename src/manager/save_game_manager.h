#ifndef SaveGameManager_H
#define SaveGameManager_H

#include <QObject>
#include <QJsonObject>
#include <QtQml/qqmlregistration.h>
#include "src/data/save_file_info.h"
#include "src/model/save_list_model.h"

class SaveGameManager : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(SaveListModel *saveListModel READ getSaveListModel CONSTANT)

public:
    static SaveGameManager* m_instance;
    explicit SaveGameManager(QObject *parent = nullptr) : QObject(parent) {
        m_instance = this;
        m_saveListModel = new SaveListModel(this);
    }

    SaveListModel* getSaveListModel();

    Q_INVOKABLE bool parseSaveGame(const QString &filePath);

    Q_INVOKABLE SaveFileInfo get(const int index);
    Q_INVOKABLE void append(const SaveFileInfo &save);
    Q_INVOKABLE void remove(const int index);

    Q_INVOKABLE void setValue(const int index, const QString &path, const QVariant &obj);
    Q_INVOKABLE void insertDirty(const int index, const QString &key, const QVariant &val);
    Q_INVOKABLE void removeDirty(const int index, const QString &key);
    Q_INVOKABLE int getDirtyCount(const int index);

    Q_INVOKABLE bool exportEncryptedFile(const QString &filePath, const int index);
    Q_INVOKABLE bool exportDecryptedFile(const QString &filePath, const int index);
    Q_INVOKABLE bool resetFile(const int index);
    Q_INVOKABLE bool saveFile(const QJsonObject &data, const int index);

private:
    SaveListModel *m_saveListModel;

};

#endif