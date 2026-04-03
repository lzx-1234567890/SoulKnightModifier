#include "file_processor.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>
#include <QFileInfo>

FileProcessor* FileProcessor::m_instance = nullptr;

QString FileProcessor::readFileByString(const QString &filePath) {
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "无法打开文件:" << filePath;
        return "";
    }

    QTextStream in(&file);
    QString content = in.readAll();
    file.close();
    return content;
}

bool FileProcessor::writeFileByString(const QString &filePath, const QString &content) {
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "无法打开文件:" << filePath;
        return false;
    }

    QTextStream out(&file);
    out << content;
    file.flush();
    file.close();
    return true;
}

QByteArray FileProcessor::readFileByByte(const QString &filePath) {
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "无法打开文件:" << filePath;
        return QByteArray();
    }

    QByteArray content = file.readAll();
    file.close();
    return content;
}

bool FileProcessor::writeFileByByte(const QString &filePath, const QByteArray &content) {
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "无法打开文件:" << filePath;
        return false;
    }

    file.write(content);
    file.flush();
    file.close();
    return true;
}

QString FileProcessor::urlToLocalFile(const QUrl &url) {
    if (url.isEmpty()) return QString();
    return url.toLocalFile();
}