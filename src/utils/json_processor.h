#ifndef JSONPROCESSOR_H
#define JSONPROCESSOR_H

#include <QObject>
#include <QtQml/qqmlregistration.h>

class JsonProcessor {

public:
    static QJsonObject setValue(QJsonObject obj, QStringList steps, const QVariant &val);
    static QString extractUid(const QString &xmlString);
    static QJsonObject convertXmlToJson(const QString &xmlString);
    static QString convertJsonToXmlTags(const QJsonObject &jsonObj);
};

#endif