#include "loggingsystem.h"
#include <QDebug>

void LoggingSystem::init()
{
    //out = new QTextStream(stdout, QIODevice::WriteOnly); //TODO: переход к записи логов в файл
}

void LoggingSystem::sendInfo(QString infoString)
{
    //*out<<'-'<<infoString<<'\n';
}

void LoggingSystem::sendError(QString errorString, ErrorType errorType)
{
    if(errorType == ErrorType::None)
    {
        //*out<<'!'<<errorString<<'\n';
    }
    else if(errorType == ErrorType::Critical)
    {
        //*out<<"!!"<<errorString<<'\n';
    }
}

void LoggingSystem::sendDebug(QString debugString)
{
    //*out<<"Debug: "<<debugString<<'\n';
}



