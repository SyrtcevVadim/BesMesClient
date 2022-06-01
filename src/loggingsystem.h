#ifndef LOGGINGSYSTEM_H
#define LOGGINGSYSTEM_H
#include <QObject>

class LoggingSystem : public QObject
{
    Q_OBJECT
public:
    LoggingSystem(QObject *parent = nullptr);
};

#endif // LOGGINGSYSTEM_H
