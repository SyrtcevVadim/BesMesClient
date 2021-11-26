#include "logsystem.h"
#include <QDebug>
#include <QDateTime>
#include <QLocale>

LogSystem::LogSystem(const QString &logFileName, QObject *parent) : QObject(parent)
{
    latestLogFile = new QFile(logFileName);
    // В начале каждой сессии файл логов перезаписывается
    if(!latestLogFile->open(QIODevice::Truncate | QIODevice::WriteOnly))
    {
        qDebug() << "!!!Файл логов не открыт";
    }
    logStream = new QTextStream(latestLogFile);
    *logStream << locale.toString(QDate::currentDate()) << ":\n";
}
LogSystem::~LogSystem()
{
    latestLogFile->close();
}

void LogSystem::logToFile(QString message, LogMessageType type)
{
    QTime now = QTime::currentTime();
    QString outMessage;
    switch(type)
    {
        case LogMessageType::Message:
            outMessage = QString("%1: %2\n").arg(locale.toString(now), message);
            break;
        case LogMessageType::Error:
            outMessage = QString("ERROR at %1: %2\n").arg(locale.toString(now), message);
            break;
    }
    *logStream << outMessage;
    logStream->flush();
    qDebug() << outMessage;
    emit messageLogged(message + '\n');
}

void LogSystem::close()
{
    latestLogFile->close();
}
