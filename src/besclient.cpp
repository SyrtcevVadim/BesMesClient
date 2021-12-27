#include "besclient.h"
#include <string>
#include <QSslConfiguration>
BesClient::BesClient()
{
    socket = new QSslSocket(this);
    out = new QTextStream(socket);
    log = new LogSystem("latest.txt");
    config = new ConfigReader("mainConfig.toml");
    setSignals();
    config->loadConfig();
    serverAddress = QString::fromStdString(config->getConfigs()["client_connection"]["server_address"].value<std::string>().value());
    serverPort    = config->getConfigs()["client_connection"]["port"].value<int>().value();

    log->logToFile(QString("Установлены следующие настройки сервера: ip - %1, порт - %2").arg(serverAddress, QString::number(serverPort)));


    setSocketSettings();
}

BesClient::~BesClient()
{
    delete socket;
    delete out;
    delete log;
    delete config;
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
        for(const QSslError &a : errors)
        {
            qDebug() << a;
        }
    });
    connect(config, SIGNAL(defaultConfigSet()),
            this,   SLOT(defaultConfigSett()));
}

void BesClient::setSocketSettings()
{
    QSslConfiguration sslConfig;
    sslConfig.setPeerVerifyMode(QSslSocket::PeerVerifyMode::QueryPeer);
    if(config->getConfigs()["ssl_configuration"]["load_local_certificate_as_ca"].value<bool>().value())
    {
        QString sertFilePath = QString::fromStdString(config->getConfigs()["ssl_configuration"]["local_certificate_path"].value<std::string>().value());
        QFile sert(sertFilePath);
        sert.open(QIODevice::ReadOnly);
        sslConfig.addCaCertificate(QSslCertificate(&sert));
    }
    if(config->getConfigs()["ssl_configuration"]["ignore_ssl_errors"].value<bool>().value())
    {
        socket->ignoreSslErrors();
    }
    socket->setSslConfiguration(sslConfig);
}

void BesClient::reloadServerProperties()
{
    config->loadConfig();
    serverAddress = QString::fromStdString(config->getConfigs()["client_connection"]["server_address"].value<std::string>().value());
    serverPort    = config->getConfigs()["client_connection"]["port"].value<int>().value();
    log->logToFile(QString("Установлены следующие настройки сервера: ip - %1, порт - %2").arg(serverAddress, QString::number(serverPort)));
}

void BesClient::connectToServer()
{
    if(socket->isEncrypted())
    {
        log->logToFile("не надо коннектится второй раз");
        return;
    }
    qDebug() << "Попытка подключения";
    if(serverAddress == "")
    {
        log->logToFile("Не введены адрес и порт сервера");
        return;
    }
    log->logToFile("Попытка подключения к серверу");
    socket->connectToHostEncrypted(serverAddress, serverPort);
    if(!socket->waitForEncrypted(2000))  //TODO избавится от ожидания
    {
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
    if(!socket->isEncrypted())
    {
        log->logToFile("Подключение к серверу не установлено, отмена операции", LogSystem::LogMessageType::Error);
        return;
    }
    log->logToFile(QString("Получены следующие данные для входа: %1 %2").arg(login, password));
    if(!socket->isWritable())
    {
        qDebug() << "Невозможно отправить сообщение на сервер";
        return;
    }
    target = RequestTarget::Login;
    QString outString = QString(LOGIN_COMMAND) + QString(" %1 %2\r\n").arg(login, password);
    log->logToFile(outString);
    *out<<outString;
    out->flush();
}

void BesClient::registration(QString name, QString surname, QString email, QString password)
{
    if(!socket->isEncrypted())
    {
        log->logToFile("Подключение к серверу не установлено, отмена операции", LogSystem::LogMessageType::Error);
        return;
    }
    log->logToFile(QString("Получены следующие данные для регистрации: %1 %2 %3 %4").arg(name, surname, email, password));
    if(!socket->isWritable())
    {
        qDebug() << "Невозможно отправить сообщение на сервер";
        return;
    }
    target = RequestTarget::Registration;
    QString outString = QString(REGISTRATION_COMMAND) + QString(" %1 %2 %3 %4\r\n").arg(name, surname, email, password);
    log->logToFile(outString);
    *out<<outString;
    out->flush();
}

void BesClient::registrationCode(int registrationCode)
{
    if(!socket->isEncrypted())
    {
        log->logToFile("Подключение к серверу не установлено, отмена операции", LogSystem::LogMessageType::Error);
        return;
    }
    log->logToFile(QString("Отправка кода %1 на проверку").arg(registrationCode));
    if(!socket->isWritable())
    {
        qDebug() << "Невозможно отправить сообщение на сервер";
        return;
    }
    target = RequestTarget::SendRegCode;
    QString outString = QString(VERIFICATION_COMMAND) + QString(" %1\r\n").arg(registrationCode);
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
    log->logToFile(data);

    QChar status = data[0];

    if(status == '+')
    {
        QString answerString = data.remove(0, 1);
        switch(target)
        {
            case RequestTarget::Login:
            {
                log->logToFile("Успешная авторизация");
                emit auntificationComplete(true, 0, answerString); // код 0 - авторизация успешна
                break;
            }
            case RequestTarget::Registration:
            {
                log->logToFile("Успешная регистрация, переход на экран ввода кода с почты");
                emit registrationComplete(true, 0, answerString);
                break;
            }
            case RequestTarget::SendRegCode:
            {
                log->logToFile("Код регистрации верный, переход на экран мессенджера");
                emit regCodeCheckingComplete(true, 0, answerString);
                break;
            }
        default:
        break;
        }
    }
    else //обработчики ошибок
    {
        int answerCode = data.split(' ')[1].toInt();
        QString answerString = data.remove(0, data.indexOf(' ', 1));
        switch(target)
        {
            case RequestTarget::Login:
            {
                log->logToFile("Ошибка авторизации, код ошибки " + QString::number(answerCode), LogSystem::LogMessageType::Error);
                emit auntificationComplete(false, answerCode, answerString);
                break;
            }
            case RequestTarget::Registration:
            {
                log->logToFile("Ошибка регистрации, код ошибки " + QString::number(answerCode), LogSystem::LogMessageType::Error);
                emit registrationComplete(false, answerCode, answerString);
                break;
            }
            case RequestTarget::SendRegCode:
            {
                log->logToFile("Ошибка проверки кода регистрации, код ошибки " + QString::number(answerCode), LogSystem::LogMessageType::Error);
                emit regCodeCheckingComplete(false, answerCode, answerString);
                break;
            }
            default:
            break;
        }
    }
    data = "";
}

void BesClient::messageLoggedResend(QString message)
{
    emit messageLogged(message);
}

void BesClient::defaultConfigSett()
{
    emit clientNotification(DEFAULT_CONFIG_ERROR_HEAD, DEFAULT_CONFIG_ERROR_MESSAGE);
}
