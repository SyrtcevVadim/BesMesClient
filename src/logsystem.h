#ifndef LOGSYSTEM_H
#define LOGSYSTEM_H
#include <QThread>
#include <QFile>
#include <QTextStream>
#include <QLocale>

#define LOG_FILE_NAME "latest.txt"



/// Объект логгирующей системы
/// TODO В случае возникновения чрезвычайной ситуации, создаётся отдельный файл,
/// в который копируется содержимое последнего файла логов.
class LogSystem : public QObject
{
    Q_OBJECT
public:
    enum class LogMessageType
    {
        Message,
        Error
    };
    LogSystem(const QString &logFileName, QObject *parent = nullptr);
    ~LogSystem();
    /// Регистрирует сообщение message в файл
    Q_INVOKABLE void logToFile(QString message, LogMessageType type = LogMessageType::Message);
    /// Закрывает файл регистрации сообщений
    Q_INVOKABLE void close();



signals:
    /// Сигнал, высылаемый после регистрации сообщения
    void messageLogged(QString message);
private:
    /// Файл, в который будут записываться логи текущего сеанса
    QFile *latestLogFile;
    /// Текстовый поток, связанный с файлом логов
    QTextStream *logStream;
    /// объект для перевода времени в строку
    QLocale locale;
};

#endif // LOGSYSTEM_H
