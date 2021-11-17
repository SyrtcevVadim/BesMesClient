#include "besclient.h"

BesClient::BesClient(QString serverAdress, int port)
{
    serverUrl = serverAdress;
    serverPort = port;
    socket = new QTcpSocket(this);
    out = new QTextStream(socket);

    connect(socket, SIGNAL(connected()),
                this,   SLOT(socketConnected()));
    connect(socket, SIGNAL(disconnected()),
                this,   SLOT(socketDisconnected()));
    connect(socket, SIGNAL(readyRead()),
                this,   SLOT(readData()));
}

BesClient::BesClient()
{
    socket = new QTcpSocket(this);
    out = new QTextStream(socket);

    connect(socket, SIGNAL(connected()),
            this,   SLOT(socketConnected()));
    connect(socket, SIGNAL(disconnected()),
            this,   SLOT(socketDisconnected()));
    connect(socket, SIGNAL(readyRead()),
            this,   SLOT(readData()));
}

void BesClient::setServer(QString serverAdress, int port)
{
    serverUrl = serverAdress;
    serverPort = port;
}

void BesClient::connectToServer()
{
    qDebug() << "Попытка подключения";
    if(serverUrl == "")
    {
        qDebug() << "Не введены адрес и порт сервера";
        return;
    }
    socket->connectToHost(serverUrl, serverPort);
    if(!socket->waitForConnected())
    {
        qDebug() << "Ошибка подключения к серверу! Возможно, сервер отключён";
    }
}

void BesClient::disconnectFromServer()
{
    socket->disconnectFromHost();
}

void BesClient::login(QString login, QString password)
{
    qDebug()<< QString("Получены следующие данные для входа: %1 %2").arg(login, password);
    if(!socket->isWritable())
    {
        qDebug() << "Невозможно отправить сообщение на сервер";
        return;
    }
    *out<<QString("HELLO %1 %2\r\n").arg(login, password);
    out->flush();
}

void BesClient::socketConnected()
{
    emit connected();
    qDebug()<<"connected";
}

void BesClient::socketDisconnected()
{
    emit disconnected();
    qDebug()<<"disconnected";
}

void BesClient::readData()
{
    static QString data="";
    data+=socket->readAll(); //собираем все пакеты ответа в одну строку и выводим результат
    if(!data.endsWith("\r\n"))
    {
        return;
    }
    qDebug() << data;
    data = "";
}
