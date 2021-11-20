#include "besclient.h"
#include <QVariantMap>

BesClient::BesClient()
{
    socket = new QTcpSocket(this);
    out = new QTextStream(socket);
    log = new LogSystem("latest.txt");

    ConfigReader test("serverconfig.json");
    QVariantMap configs = test.getConfigs();

    setSignals();

    serverUrl = configs["serverAddress"].toString();
    serverPort = configs["serverPort"].toInt();
    log->logToFile(QString("Установлены следующие настройки сервера: ip - %1, порт - %2").arg(serverUrl, serverPort));
}

void BesClient::setSignals()
{
    connect(socket, SIGNAL(connected()),
            this,   SLOT(socketConnected()));
    connect(socket, SIGNAL(disconnected()),
            this,   SLOT(socketDisconnected()));
    connect(socket, SIGNAL(readyRead()),
            this,   SLOT(readData()));
    connect(log , SIGNAL(messageLogged(QString)),
            this , SLOT (messageLoggedResend(QString)));
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
    log->logToFile("Попытка подключения к серверу");
    socket->connectToHost(serverUrl, serverPort);
    if(!socket->waitForConnected(2000))
    {
        qDebug() << "Ошибка подключения к серверу! Возможно, сервер отключён";
        log->logToFile("Ошибка подключения к серверу! Возможно, сервер отключён");
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
    QString outString = QString("ПРИВЕТ %1 %2\r\n").arg(login, password);
    log->logToFile(outString);
    *out<<outString;
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
    data+=out->readAll(); //собираем все пакеты ответа в одну строку и выводим результат
    if(!data.endsWith("\r\n"))
    {
        return;
    }
    qDebug() << data;
    log->logToFile(data);
    data = "";
}

void BesClient::messageLoggedResend(QString message)
{
    emit messageLogged(message);
}
