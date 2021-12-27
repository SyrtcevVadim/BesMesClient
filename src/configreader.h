#ifndef CONFIGREADER_H
#define CONFIGREADER_H
#include <QString>
#include <QVariant>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QVector>
#include <vector>
#include <string>

#include "lib/include/toml.hpp"

class ConfigReader : public QObject
{
    Q_OBJECT
public:
    ///Класс-обертка для работы с json файлами конфигурации сервера
    /// configFileName - имя файла в папке config
    /// configFileDirectory - путь к папке с файлами конфигурации (по умолчанию папка config
    ConfigReader(QString configFileName, QDir configFileDirectory = QDir(QDir::currentPath() + "/config"));
    ~ConfigReader();
    ///Метод возвращает содержимое файла конфигурации в виде QMap<QString, QVariant> (aka QVariantMap)
    toml::table getConfigs();
    ///Проверка выбранного файла на наличие необходимых полей и загрузка значений из файла
    void loadConfig();
signals:
    void defaultConfigSet();
private:
    ///Путь к папке с файлами конфигурации
    QDir configFileDirectory;
    ///Файл конфигурации с которого считываются данные
    QFile *configFile;
    ///имя конфиг файла в конечной папке config и в ресурсах resources/config
    QString configFileName;
    ///таблица полей конфиг файла
    toml::table configs;
    void checkNode(toml::table table, std::string key, QString previousLevelName, QStringList& items);
};

#endif // CONFIGREADER_H
