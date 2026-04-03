#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QSettings>
#include <QIcon>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Basic");

    app.setOrganizationName("lzxnone");
    app.setOrganizationDomain("lzxnone.cloud");
    app.setApplicationName("SoulKnightModifier");
    app.setApplicationVersion(APP_VERSION);
    QSettings::setDefaultFormat(QSettings::IniFormat);

    app.setWindowIcon(QIcon(":/SoulKnightModifier/src/app_icon.ico"));

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SoulKnightModifier", "Main");

    return QCoreApplication::exec();
}
