#ifndef DEFAULTSETTINGS_H
#define DEFAULTSETTINGS_H

#include <QString>

namespace DefaultSettings {
    // настройки подключения к серверу
    const QString serverAddress{u"127.0.0.1"_qs};
    const QString serverport{u"1234"_qs};

    //настройки системы логирования
    const QString logFileName{u"log.txt"_qs};
}
#endif // DEFAULTSETTINGS_H
