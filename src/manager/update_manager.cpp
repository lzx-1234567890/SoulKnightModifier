#include "update_manager.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QCoreApplication>
#include <QVersionNumber>
#include <QJsonArray>

UpdateManager::UpdateManager(QObject *parent) : QObject(parent) {
    m_networkManager = new QNetworkAccessManager(this);
}

void UpdateManager::checkForUpdates() {
    QNetworkRequest request(checkUrl);

    QNetworkReply *reply = m_networkManager->get(request);
    connect(reply, &QNetworkReply::finished, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray data = reply->readAll();
            QJsonDocument doc = QJsonDocument::fromJson(data);
            QJsonObject obj = doc.object();

            QString latestVersion = obj["version"].toString();
            QString downloadUrl = obj["url"].toString();

            QString updateLog = "";
            if (obj["changelog"].isArray()) {
                QJsonArray logArray = obj["changelog"].toArray();
                for (int i = 0; i < logArray.size(); ++i) {
                    updateLog += logArray[i].toString() + "\n";
                }
            } else {
                updateLog = obj["changelog"].toString();
            }

            QVersionNumber current = QVersionNumber::fromString(qApp->applicationVersion());
            QVersionNumber latest = QVersionNumber::fromString(latestVersion);

            if (latest > current) {
                emit updateAvailable(latestVersion, updateLog, downloadUrl);
            } else {
                emit noUpdate();
            }
        } else {
            emit checkFailed();
        }
        reply->deleteLater();
    });
}