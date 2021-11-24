#include "besclient.h"
#include <QVariantMap>
#include <QSslError>


BesClient::BesClient()
{
    socket = new QSslSocket(this);
    out = new QTextStream(socket);
    log = new LogSystem("latest.txt");

    ConfigReader test("serverconfig.json");
    if(!test.checkConfig({"serverAddress", "serverPort"}))
    {
        log->logToFile("ERROR: Файл конфигурации настроек подключений к серверу нарушен.\n\r Будут исполбзованны стандартные настройки");
        serverUrl = CLIENT_CONNECTION_SERVERADDRESS;
        serverPort = CLIENT_CONNECTION_SERVERPORT;
    }
    else
    {
        QVariantMap configs = test.getConfigs();
        serverUrl = configs["serverAddress"].toString();
        serverPort = configs["serverPort"].toInt();
    }

    setSignals();

    log->logToFile(QString("Установлены следующие настройки сервера: ip - %1, порт - %2").arg(serverUrl, QString::number(serverPort)));

    socket->setPeerVerifyMode(QSslSocket::QueryPeer);
    QFile sert("besmes.crt");
    sert.open(QIODevice::ReadOnly);
    //socket->addCaCertificate(QSslCertificate(&sert));
    socket->ignoreSslErrors();
}

void BesClient::setSignals()
{
    connect(socket, SIGNAL(encrypted()),
            this,   SLOT(socketConnected()));
    connect(socket, SIGNAL(disconnected()),
            this,   SLOT(socketDisconnected()));
    connect(socket, SIGNAL(readyRead()),
            this,   SLOT(readData()));
    connect(log , SIGNAL(messageLogged(QString)),
            this , SLOT (messageLoggedResend(QString)));
    connect(socket, QOverload<const QList<QSslError> &> :: of(&QSslSocket::sslErrors),
            [=](const QList<QSslError> &errors){
        for(QSslError a : errors)
        {
            qDebug() << a;
        }
    });
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
    socket->connectToHostEncrypted(serverUrl, serverPort);
    if(!socket->waitForEncrypted(2000))
    {
        qDebug() << "Ошибка подключения к серверу! Возможно, сервер отключён";
        log->logToFile("Ошибка подключения к серверу! Возможно, сервер отключён");
    }
    qDebug()<<socket->isEncrypted();
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
