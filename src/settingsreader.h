#ifndef SETTINGSREADER_H
#define SETTINGSREADER_H

#include <QString>
#include <QSettings>

#include "defaultsettings.h"

class SettingsReader
{
public:
    static QString getServerAddress();
    static int getServerPort();

    static QString getLogFileName();
};

#endif // SETTINGSREADER_H
