#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QDebug>
#include "cppinterface.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("config");
    QCoreApplication::setApplicationName("BesMesClient");

    QSettings::setDefaultFormat(QSettings::IniFormat);
    QSettings::setPath(QSettings::IniFormat, QSettings::SystemScope, "./");
    QSettings::setPath(QSettings::IniFormat, QSettings::UserScope, "./");

    QQmlApplicationEngine engine;

    qmlRegisterType<CppInterface>("com.test.object", 1, 0, "CppInterface");

    const QUrl url("qrc:/qml/main.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);



    return app.exec();
}
