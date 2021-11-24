#ifndef CONFIGREADER_H
#define CONFIGREADER_H
//Автор: Воропаев Владимир Геннадьевич
#include <QString>
#include <QVariant>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QVector>
#include <vector>

class ConfigReader
{
public:
    ///Класс-обертка для работы с json файлами конфигурации сервера
    /// configFileName - имя файла в папке config
    /// configFileDirectory - путь к папке с файлами конфигурации (по умолчанию папка config
    ConfigReader(QString configFileName, QDir configFileDirectory = QDir(QDir::currentPath() + "/config"));
    ~ConfigReader();
    ///Метод возвращает содержимое файла конфигурации в виде QMap<QString, QVariant> (aka QVariantMap)
    QVariantMap getConfigs();
    ///Проверка выбранного файла на наличие указанных полей
    bool checkConfig(QVector<QString> requiredFields);

private:
    ///Путь к папке с файлами конфигурации
    QDir configFileDirectory;
    ///Файл конфигурации с которого считываются данные
    QFile *configFile;
};

#endif // CONFIGREADER_H
