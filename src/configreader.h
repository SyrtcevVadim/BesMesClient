#ifndef CONFIGREADER_H
#define CONFIGREADER_H
#include <QString>
#include <QVariant>
#include <QDebug>
#include <QFile>
#include <QDir>

class ConfigReader
{
public:
    ///Класс-обертка для работы с json файлами конфигурации сервера
    ConfigReader(QString configFileName);
    ~ConfigReader();

    QVariantMap getConfigs();

private:
    QDir configFileDirectory;
    QFile *configFile;
};

#endif // CONFIGREADER_H
