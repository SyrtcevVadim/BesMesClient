#ifndef BESCLIENT_H
#define BESCLIENT_H
#include "configreader.h"
#include "logsystem.h"
#include "besclientdefaultconfigs.h"

#include <QObject>
#include <QTcpSocket>
#include <QSslSocket>
#include <QDebug>

class BesClient : public QObject
{
    Q_OBJECT
public:
    BesClient();
    ///изменение адреса и порта сервера
    Q_INVOKABLE void setServer(QString serverAdress, int port); //deprecated, мб понадобится
    ///выполнить подключение к серверу
    Q_INVOKABLE void connectToServer();     //имя connect занято, так что пишем длинное название
    ///отключится от сервера
    Q_INVOKABLE void disconnectFromServer();
    ///выполнить процедуру входа в аккаунт
    Q_INVOKABLE void login(QString login, QString password);
    ///выполнить процедуру регистрации
    Q_INVOKABLE void registration(QString name, QString surname, QString email, QString password);

signals:
    ///сигнал издается при подключении к серверу
    void connected();
    ///сигнал издается при отключении от сервера
    void disconnected();
    ///издается после процедуры входа в аккаунт
    void auntificationCompleted(int answerCode);
    ///сигнал логирующей системы, высылаемый после регистрации сообщения
    void messageLogged(QString messageLogged);

    void registrationCompleted();

private:
    ///сокет подключения к серверу
    QSslSocket *socket;
    ///текстовый поток ввода-вывода сокета
    QTextStream *out;
    ///
    QString serverAddress;
    int serverPort;
    LogSystem *log;



    ///первоначальное связывание сигналов и слотов
    void setSignals();

private slots:
    ///
    void socketConnected();
    void socketDisconnected();
    void readData();
    void messageLoggedResend(QString messageLogged);
};

#endif // BESCLIENT_H
