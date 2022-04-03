#ifndef SETTINGSREADER_H
#define SETTINGSREADER_H

#include <QString>

class SettingsReader
{
public:
    SettingsReader();

    QString getServerAddress();
    int  getServerPort();

    QString getLogFileName();
    //и так далее
};

#endif // SETTINGSREADER_H
