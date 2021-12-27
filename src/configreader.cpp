#include "configreader.h"

ConfigReader::ConfigReader(QString configFileName, QDir configFileDirectory)
{
    this->configFileDirectory = configFileDirectory;
    if(!configFileDirectory.exists())
    {
        configFileDirectory.mkpath(".");
    }
    configFile = new QFile(configFileDirectory.path() + '/' + configFileName);
    this->configFileName = configFileName;
}

ConfigReader::~ConfigReader()
{
    delete configFile;
}

toml::table ConfigReader::getConfigs()
{
    return configs;
}

void ConfigReader::checkNode(toml::table table, std::string key, QString previousLevelName, QStringList& items)
{
    if(table[key].is_table())
    {
        for(auto item : *table[key].as_table())
        {
            checkNode(*table[key].as_table(), item.first, QString("%1 %2").arg(previousLevelName, QString::fromStdString(key)), items);
        }
    }
    else{
        items.append(QString("%1 %2").arg(previousLevelName, QString::fromStdString(key)));
    }
}

void ConfigReader::loadConfig()
{
    QFile defaultConfig(":/mainConfig.toml");
    configFile->open(QIODevice::ReadOnly | QIODevice::Text);
    defaultConfig.open(QIODevice::ReadOnly | QIODevice::Text);

    QString defaultConfigStr = defaultConfig.readAll();
    QString configStr = configFile->readAll();

    toml::table defaultConfigTable = toml::parse(defaultConfigStr.toStdString());
    configs = toml::parse(configStr.toStdString());
    //обходим все узлы обоих таблиц,
    //если они совпадают - конфиг файл соответствует шаблону
    QStringList itemsInDefaultConfig, itemsInConfig;
    for(auto item : defaultConfigTable)
    {
        checkNode(defaultConfigTable, item.first, "root", itemsInDefaultConfig);
    }
    for(auto item : configs)
    {
        checkNode(configs, item.first, "root", itemsInConfig);
    }
    defaultConfig.close();
    configFile->close();
    if(!(itemsInDefaultConfig == itemsInConfig))
    {
        if(configFile->exists())
        {
            configFile->remove();
        }
        defaultConfig.copy(configFileDirectory.path() + '/' + configFileName);
        configs = defaultConfigTable;
        emit defaultConfigSet();
    }
}
