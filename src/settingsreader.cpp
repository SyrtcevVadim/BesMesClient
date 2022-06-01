#include "settingsreader.h"

QString SettingsReader::getServerAddress()
{
    QSettings settingsObj;
    settingsObj.beginGroup("Connection");
    if(settingsObj.contains("serverAddress"))
    {
        return settingsObj.value("serverAddress").toString();
    }
    else
    {
        settingsObj.setValue("serverAddress", DefaultSettings::serverAddress);
        return DefaultSettings::serverAddress;
    }
}

int SettingsReader::getServerPort()
{
    QSettings settingsObj;
    settingsObj.beginGroup("Connection");
    if(settingsObj.contains("serverPort"))
    {
        QString portCandidate = settingsObj.value("serverPort").toString();
        bool isOk;
        int port = portCandidate.toInt(&isOk);
        if(isOk)
            return port;
        else
        {
            settingsObj.setValue("serverPort", DefaultSettings::serverPort);
            return DefaultSettings::serverPort;
        }
    }
    else
    {
        settingsObj.setValue("serverPort", DefaultSettings::serverPort);
        return DefaultSettings::serverPort;
    }
}

QString SettingsReader::getLogFileName()
{
    QSettings settingsObj;
    settingsObj.beginGroup("Logging");
    if(settingsObj.contains("logFileName"))
    {
        return settingsObj.value("logFileName").toString();
    }
    else
    {
        settingsObj.setValue("logFileName", DefaultSettings::serverAddress);
        return DefaultSettings::serverAddress;
    }
}
