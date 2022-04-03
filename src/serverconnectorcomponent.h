#ifndef SERVERCONNECTORCOMPONENT_H
#define SERVERCONNECTORCOMPONENT_H

#include "settingsreader.h"

class ServerConnectorComponent
{
public:
    ServerConnectorComponent();

private:
    SettingsReader *settings;
};

#endif // SERVERCONNECTORCOMPONENT_H
