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

bool ConfigReader::checkConfig(QVector<QString> requiredFields)
{
    configFile->open(QIODevice::ReadWrite | QIODevice::Text);
    QByteArray jsonString = configFile->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(jsonString);
    QJsonObject obj = doc.object();

    bool isBroken = false;

    for(const QString &a : requiredFields)
    {
        if(!obj.contains(a))
        {
            isBroken = true;
        }
        else if(obj.take(a).toString() == "")
        {
            isBroken = true;
        }
    }

    if(isBroken)
    {
        QJsonObject newObj;
        for(const QString &a : requiredFields)
        {
            newObj.insert(a, "");
        }
        doc = QJsonDocument();
        doc.setObject(newObj);
        configFile->remove();
        configFile->open(QIODevice::ReadWrite | QIODevice::Text);
        configFile->write(doc.toJson());
        configFile->close();
        return false;
    }
    else
    {
        configFile->close();
        return true;
    }
}
