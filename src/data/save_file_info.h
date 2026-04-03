#ifndef SaveFileInfo_H
#define SaveFileInfo_H

#include <QObject>
#include <QJsonObject>

class SaveFileInfo {
    Q_GADGET
    Q_PROPERTY(QString fileName MEMBER fileName)
    Q_PROPERTY(QString filePath MEMBER filePath)
    Q_PROPERTY(int fileType MEMBER fileType)
    Q_PROPERTY(QJsonObject originalContent MEMBER originalContent)
    Q_PROPERTY(QJsonObject modifiedContent MEMBER modifiedContent)

public:
    QString filePath, fileName;
    int fileType, decryptType;
    QJsonObject originalContent, modifiedContent;
    QVariantHash dirtyValue;
    int dirtyCount = 0;
    //long long uid;
    SaveFileInfo(const QString &filePath, const QString &fileName, const int fileType, const int decryptType);
};

#endif