#include "configreader.h"
#include <QJsonDocument>
#include <QJsonObject>
#include "lib/include/toml.hpp"
#include <string>
ConfigReader::ConfigReader(QString configFileName, QDir configFileDirectory) : QObject(nullptr)
{
    this->configFileDirectory = configFileDirectory;
    if(!configFileDirectory.exists())
    {
        configFileDirectory.mkpath(".");
    }
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
void check(toml::table table, std::string key)
{
    if(table[key].is_table())
    {
        qDebug() << "enter table "<<QString::fromStdString(key);
        for(auto item : *table[key].as_table())
        {
            check(*table[key].as_table(), item.first);
        }
    }
    else{
        qDebug() << QString::fromStdString(key);
    }
}

void ConfigReader::checkConfig(QString fileName)
{
    QFile defaultConfig(":/mainConfig.toml");
    qDebug() << defaultConfig.open(QIODevice::ReadOnly | QIODevice::Text);
    QString confStr = defaultConfig.readAll();
    toml::table configTable = toml::parse(confStr.toStdString());
    for(auto item : configTable)
    {
        check(configTable, item.first);
    }

}


