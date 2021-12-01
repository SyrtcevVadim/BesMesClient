#ifndef BESCLIENT_H
#define BESCLIENT_H
#include "configreader.h"
#include "logsystem.h"
#include "besclientdefaultconfigs.h"

#include <QObject>
#include <QTcpSocket>
#include <QSslSocket>
#include <QDebug>

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
    ///изменение адреса и порта сервера
    Q_INVOKABLE void reloadServerProperties(); //используется в экране разработчика
    ///выполнить подключение к серверу
    Q_INVOKABLE void connectToServer();     //имя connect занято, так что пишем длинное название
    ///отключится от сервера
    Q_INVOKABLE void disconnectFromServer();

    //процедуры общения клиента с сервером
    ///выполнить процедуру входа в аккаунт
    Q_INVOKABLE void login(QString login, QString password);
    ///выполнить процедуру регистрации
    Q_INVOKABLE void registration(QString name, QString surname, QString email, QString password);
    ///выполнить процедуру проверки кода регистрации
    Q_INVOKABLE void registrationCode(int registrationCode);

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
    LogSystem *log;
    ///сохраняет цель текущего обращения клиента к серверу для последующей обработки ответа
    RequestTarget target;
    ///если true, после разрыва соединения клиент попытается восстановить его
    bool keepConnected;

    ///первоначальное связывание сигналов и слотов
    void setSignals();

private slots:
    ///
    void socketConnected();
    void socketDisconnected();
    void readData();
    void messageLoggedResend(QString messageLogged);

    void setSocketSettings();
};

#endif // BESCLIENT_H
