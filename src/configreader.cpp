#include "configreader.h"
#include <QJsonDocument>
#include <QJsonObject>

ConfigReader::ConfigReader(QString configFileName)
{
    configFileDirectory = QDir(QDir::currentPath() + "/config");

    configFile = new QFile(configFileDirectory.path() + '/' + configFileName);
}

ConfigReader::~ConfigReader()
{
    delete configFile;
}

QVariantMap ConfigReader::getConfigs()
{
    QVariantMap map;
    configFile->open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray jsonString = configFile->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(jsonString);
    QJsonObject obj = doc.object();
    map = obj.toVariantMap();
    configFile->close();
    return map;
}
