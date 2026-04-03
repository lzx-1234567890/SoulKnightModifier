#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QtQml/qqmlregistration.h>

class UpdateManager : public QObject {
    Q_OBJECT
    QML_ELEMENT

public:
    explicit UpdateManager(QObject *parent = nullptr);

    Q_INVOKABLE void checkForUpdates();

signals:
    void updateAvailable(QString newVersion, QString log, QString url);
    void noUpdate();
    void checkFailed();

private:
    const QUrl checkUrl = QUrl("https://server.lzxnone.cloud/SoulKnightModifier/version.json");
    QNetworkAccessManager *m_networkManager;
};