#include "configreader.h"
#include <QJsonDocument>
#include <QJsonObject>

ConfigReader::ConfigReader(QString configFileName, QDir configFileDirectory)
{
    this->configFileDirectory = configFileDirectory;

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

    //тк конфигурационный файл по сути - объект json
    QJsonDocument doc = QJsonDocument::fromJson(jsonString);
    //рассматриваем документ json как содержимое одного объекта
    QJsonObject obj = doc.object();

    map = obj.toVariantMap();
    configFile->close();
    return map;
}
