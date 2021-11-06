#ifndef BESCLIENT_H
#define BESCLIENT_H

#include <QObject>
#include <QTcpSocket>
#include <QDebug>

class BesClient : public QObject
{
    Q_OBJECT
public:
    BesClient(QString serverAdress, int port);
    BesClient();
    Q_INVOKABLE void setServer(QString serverAdress, int port);
    Q_INVOKABLE void connectToServer();     //имя connect занято, так что пишем длинное название
    Q_INVOKABLE void disconnectFromServer();
    Q_INVOKABLE void login(QString login, QString password);

signals:
    ///сигнал издается при подключении к серверу
    void connected();
    ///сигнал издается при отключении от сервера
    void disconnected();
    ///издается после процедуры входа в аккаунт
    void auntificationCompleted(bool success);

private:
    QTcpSocket *socket;
    QTextStream *out;
    QString serverUrl;
    int serverPort;

private slots:
    void socketConnected();
    void socketDisconnected();
    void readData();
};

#endif // BESCLIENT_H
