#ifndef BESCLIENT_H
#define BESCLIENT_H
#include "configreader.h"
#include "logsystem.h"

#include <QObject>
#include <QTcpSocket>
#include <QDebug>

class BesClient : public QObject
{
    Q_OBJECT
public:
    BesClient();
    ///изменение адреса и порта сервера
    Q_INVOKABLE void setServer(QString serverAdress, int port);
    ///выполнить подключение к серверу
    Q_INVOKABLE void connectToServer();     //имя connect занято, так что пишем длинное название
    ///отключится от сервера
    Q_INVOKABLE void disconnectFromServer();
    ///выполнить процедуру входа в аккаунт
    Q_INVOKABLE void login(QString login, QString password);

signals:
    ///сигнал издается при подключении к серверу
    void connected();
    ///сигнал издается при отключении от сервера
    void disconnected();
    ///издается после процедуры входа в аккаунт
    void auntificationCompleted(bool success);
    ///сигнал логирующей системы, высылаемый после регистрации сообщения
    void messageLogged(QString messageLogged);

private:
    QTcpSocket *socket;
    QTextStream *out;
    QString serverUrl;
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
