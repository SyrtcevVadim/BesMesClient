#ifndef LOGGINGSYSTEM_H
#define LOGGINGSYSTEM_H

#include <QTextStream>

class LoggingSystem
{
    ///Класс ошибки. В зависимости от класса, форматирование ошибки будет отличатся
    enum class ErrorType
    {
        None,
        Critical
    };

public:
    ///Выводит отладочную информацию в логи
    static void sendInfo(QString infoString);
    ///Выводит информацию об ошибке в логи
    static void sendError(QString errorString, ErrorType errorType = ErrorType::None);
    ///Выводит отладочную информацию
    static void sendDebug(QString debugString);
    ///Установка всех зависимостей и получение потока на вывод логов
    static void init();
private:
    ///Поток вывода записей системы
    static QTextStream *out;
    //TODO: вывод в файл, отдельный поток для отладочной информации
};

#endif // LOGGINGSYSTEM_H
