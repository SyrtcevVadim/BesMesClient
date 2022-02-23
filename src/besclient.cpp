#include "besclient.h"

BesClient::BesClient()
{
    socket = new QSslSocket(this);
    out = new QTextStream(socket);
    loggingSystem = new LogSystem("latest.txt");
    config = new ConfigReader("mainConfig.toml");
    setSignals();
    config->loadConfig();
    serverAddress = QString::fromStdString(config->getConfigs()["client_connection"]["server_address"].value<std::string>().value());
    serverPort    = config->getConfigs()["client_connection"]["port"].value<int>().value();

    loggingSystem->logToFile(QString("Установлены следующие настройки сервера: ip - %1, порт - %2").arg(serverAddress, QString::number(serverPort)));


    setSocketSettings();
}

BesClient::~BesClient()
{
    delete socket;
    delete out;
    delete loggingSystem;
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
    connect(loggingSystem , SIGNAL(messageLogged(QString)),
            this , SLOT (messageLoggedResend(QString)));
    connect(socket, QOverload<const QList<QSslError> &> :: of(&QSslSocket::sslErrors),
            [=](const QList<QSslError> &errors){
        for(const QSslError &a : errors)
        {
            qDebug() << a;
        }
    });
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
    loggingSystem->logToFile(QString("Установлены следующие настройки сервера: ip - %1, порт - %2").arg(serverAddress, QString::number(serverPort)));
}

void BesClient::connectToServer()
{
    QVector<QVariant> testArray;
    testArray.append(QVariant(QString("string")));
    testArray.append(QVariant(123));
    testArray.append(QVariant(true));
    emit clientMessage("testSignal", 0, testArray);
    if(socket->isEncrypted())
    {
        loggingSystem->logToFile("не надо коннектится второй раз");
        return;
    }
    qDebug() << "Попытка подключения";
    if(serverAddress == "")
    {
        loggingSystem->logToFile("Не введены адрес и порт сервера");
        return;
    }
    loggingSystem->logToFile("Попытка подключения к серверу");
    socket->connectToHostEncrypted(serverAddress, serverPort);
    if(!socket->waitForEncrypted(2000))  //TODO избавится от ожидания
    {
        loggingSystem->logToFile("Ошибка подключения к серверу! Возможно, сервер отключён");
    }
    qDebug()<<socket->isEncrypted();
}

void BesClient::disconnectFromServer()
{
    socket->disconnectFromHost();
}

void BesClient::makeRequest(QString requestType, QVector<QString> data)
{
    if(!socket->isEncrypted())
    {
        loggingSystem->logToFile("Подключение к серверу не установлено, отмена операции", LogSystem::LogMessageType::Error);
        return;
    }
    QString outString;
    if(requestType == "login")
    {
        target = RequestTarget::Login;
        outString = QString(LOGIN_COMMAND) + QString(" %1 %2\r\n").arg(data[0], data[1]);
    }
    else if(requestType == "registration")
    {
        target = RequestTarget::Registration;
        outString = QString(REGISTRATION_COMMAND) + QString(" %1 %2 %3 %4\r\n").arg(data[0], data[1], data[2], data[3]);
    }
    else if(requestType == "regCode")
    {
        target = RequestTarget::RegCode;
        outString =  QString(VERIFICATION_COMMAND) + QString(" %1\r\n").arg(data[0]);
    }
    else{
        loggingSystem->logToFile("Неизвестный запрос " + requestType, LogSystem::LogMessageType::Error);
        return;
    }
    loggingSystem->logToFile(outString);
    *out<<outString;
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
    loggingSystem->logToFile(data);

    QChar status = data[0];

    if(status == '+')
    {
        QString answerString = data.remove(0, 1);
        switch(target)
        {
            case RequestTarget::Login:
            {
                loggingSystem->logToFile("Успешная авторизация");
                emit clientMessage("loginCompleted", 0, QVector<QVariant>({QVariant(answerString)})); // код 0 - авторизация успешна
                break;
            }
            case RequestTarget::Registration:
            {
                loggingSystem->logToFile("Успешная регистрация, переход на экран ввода кода с почты");
                emit clientMessage("registrationCompleted", 0, QVector<QVariant>({QVariant(answerString)}));
                break;
            }
            case RequestTarget::RegCode:
            {
                loggingSystem->logToFile("Код регистрации верный, переход на экран мессенджера");
                emit clientMessage("regCodeCompleted", 0, QVector<QVariant>({QVariant(answerString)}));
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
                loggingSystem->logToFile("Ошибка авторизации, код ошибки " + QString::number(answerCode), LogSystem::LogMessageType::Error);
                emit clientMessage("loginCompleted", answerCode, QVector<QVariant>({QVariant(answerString)}));
                break;
            }
            case RequestTarget::Registration:
            {
                loggingSystem->logToFile("Ошибка регистрации, код ошибки " + QString::number(answerCode), LogSystem::LogMessageType::Error);
                emit clientMessage("registrationCompleted", answerCode, QVector<QVariant>({QVariant(answerString)}));
                break;
            }
            case RequestTarget::RegCode:
            {
                loggingSystem->logToFile("Ошибка проверки кода регистрации, код ошибки " + QString::number(answerCode), LogSystem::LogMessageType::Error);
                emit clientMessage("regCodeCompleted", answerCode, QVector<QVariant>({QVariant(answerString)}));
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
    emit clientMessage("log", 0, QVector<QVariant>({QVariant(message)}));;
}

void BesClient::log(QString externalMessage)
{
    loggingSystem->logToFile(externalMessage);
}
