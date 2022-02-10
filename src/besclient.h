#ifndef BESCLIENT_H
#define BESCLIENT_H
#include "configreader.h"
#include "logsystem.h"
#include "BesProtocol.h"

#include <QObject>
#include <QSslSocket>
#include <QDebug>
#include <QSslError>

#define DEFAULT_CONFIG_ERROR_HEAD    QString("Файл конфигурации поврежден")
#define DEFAULT_CONFIG_ERROR_MESSAGE QString("Установлены настройки по умолчанию\nЕсли необходимо, измените настройки и перезапустите клиент")

enum class RequestTarget
{
    None,
    Login,
    Registration,
    SendRegCode
};

class BesClient : public QObject
{
    Q_OBJECT
public:
    BesClient();
    ~BesClient();
    ///изменение адреса и порта сервера
    Q_INVOKABLE void reloadServerProperties(); //используется в экране разработчика
    ///выполнить подключение к серверу
    Q_INVOKABLE void connectToServer();     //имя connect занято, так что пишем длинное название
    ///отключится от сервера
    Q_INVOKABLE void disconnectFromServer();
    ///сделать запись в общий лог клиента
    Q_INVOKABLE void log(QString logString);

    //процедуры общения клиента с сервером
    ///выполнить процедуру входа в аккаунт
    Q_INVOKABLE void login(QString login, QString password);
    ///выполнить процедуру регистрации
    Q_INVOKABLE void registration(QString name, QString surname, QString email, QString password);
    ///выполнить процедуру проверки кода регистрации
    Q_INVOKABLE void registrationCode(int registrationCode);

    Q_INVOKABLE void makeRequest(QString requestType, QVector<QVariant> data);

signals:
    ///сигнал издается при подключении к серверу
    void connected();
    ///сигнал издается при отключении от сервера
    void disconnected();
    ///издается после окончания процедуры входа в аккаунт
    void auntificationComplete(bool success, int answerCode, QString answerText);
    ///сигнал логирующей системы, высылаемый после регистрации сообщения
    void messageLogged(QString messageLogged);
    ///издается после окончания процедуры регистрации, при успехе - перейти на экран ввода кода регистрации
    void registrationComplete(bool success, int answerCode, QString answerText);
    ///издается после окончания процедуры проверки кода регистрации
    void regCodeCheckingComplete(bool success, int answerCode, QString answerText);

    void clientNotification(QString header, QString message);
    ///сигнал издается при необходимости передать информацию от с++ клиента к QML
    void clientMessage(QString message, int errorCode, QVector<QVariant> additionalData);
private:
    ///сокет подключения к серверу
    QSslSocket *socket;
    ///текстовый поток ввода-вывода сокета
    QTextStream *out;
    ///адрес сервера
    QString serverAddress;
    ///порт сервера
    int serverPort;
    ///объект логирующей системы
    LogSystem *loggingSystem;
    ///сохраняет цель текущего обращения клиента к серверу для последующей обработки ответа
    RequestTarget target;
    ///если true, после разрыва соединения клиент попытается восстановить его
    bool keepConnected;
    ///объект, взаимодействующий с конфигами
    ConfigReader *config;

    ///первоначальное связывание сигналов и слотов
    void setSignals();

private slots:
    void socketConnected();
    void socketDisconnected();
    void readData();
    void messageLoggedResend(QString messageLogged);

    void setSocketSettings();
};

#endif // BESCLIENT_H
