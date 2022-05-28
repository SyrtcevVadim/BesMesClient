#include "cppinterface.h"
#include <QSettings>

CppInterface::CppInterface(QObject* parent) : QObject(parent)
{
    connection = new ServerConnectorComponent();
    setSignals();
}

CppInterface::~CppInterface()
{
    delete connection;
}

void CppInterface::connectToServer()
{
    connection->connect();
}

void CppInterface::disconnectFromServer()
{
    connection->disconnect();
}

void CppInterface::sendLoginRequest(QString email, QString password)
{
    QString request = RequestCreator::createLoginRequest(email, password);
    connection->sendRequest(request);
}

void CppInterface::sendRegistrationRequest(QString name, QString surname, QString email, QString password)
{
    QString request = RequestCreator::createRegistrationRequest(name, surname, email, password);
    connection->sendRequest(request);
}

void CppInterface::sendChatCreationRequest(const QString name)
{
    QString request = RequestCreator::createChatCreationRequest(name);
    connection->sendRequest(request);
}

void CppInterface::sendChatRemovingtRequest(const int chat_id)
{
    QString request = RequestCreator::createChatRemovingtRequest(chat_id);
    connection->sendRequest(request);
}

void CppInterface::sendChatListRequest()
{
    QString request = RequestCreator::createChatListRequest();
    connection->sendRequest(request);
}

void CppInterface::connectionStatusChanged(bool status)
{
    emit serverStatusChanged((int)status);
}

void CppInterface::serverMessageRecieved(QString serverMessage)
{
    qDebug() <<"сервер вернул " << serverMessage;
    QJsonObject requestResult = QJsonDocument::fromJson(serverMessage.toUtf8()).object();
    QString answerType = requestResult["тип_запроса"].toString();

    using namespace RequestCreator;

    if(answerType == loginCommand)
    {
        int errorCode = requestResult["код_ответа"].toInt();
        emit loginRequestCompleted(errorCode);
    }
    else if(answerType == registrationCommand)
    {
        int errorCode = requestResult["код_ответа"].toInt();
        emit registrationRequestCompleted(errorCode);
    }
    else if(answerType == chatListCommand)
    {

    }
    else if(answerType == chatCreateCommand)
    {

    }
    else if(answerType == chatRemoveCommand)
    {

    }
}

void CppInterface::setSignals()
{
    QObject::connect(connection, &ServerConnectorComponent::connectionStatusChanged,
                     this,       &CppInterface::connectionStatusChanged);
    QObject::connect(connection, &ServerConnectorComponent::serverMessage,
                     this,       &CppInterface::serverMessageRecieved);
}

void CppInterface::startApplication()
{
    connectToServer();
    qDebug() << "Подключаемся";
}
