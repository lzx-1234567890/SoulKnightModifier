#ifndef FILEPROCESSOR_H
#define FILEPROCESSOR_H

#include <QObject>
#include <QtQml/qqmlregistration.h>

class FileProcessor : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    static FileProcessor* m_instance;
    explicit FileProcessor(QObject *parent = nullptr) : QObject(parent) {
        m_instance = this;
    }

    Q_INVOKABLE QString readFileByString(const QString &filePath);
    Q_INVOKABLE bool writeFileByString(const QString &filePath, const QString &content);
    Q_INVOKABLE QByteArray readFileByByte(const QString &filePath);
    Q_INVOKABLE bool writeFileByByte(const QString &filePath, const QByteArray &content);

    Q_INVOKABLE QString urlToLocalFile(const QUrl &url);
};

#endif