#include "cppinterface.h"
#include <QSettings>

CppInterface::CppInterface(QObject* parent) : QObject(parent)
{
    connection = new ServerConnectorComponent();
    m_user_id = 3;
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
    m_email = email;
    QString request = RequestCreator::createLoginRequest(email, password);
    connection->sendRequest(request);
}

void CppInterface::sendRegistrationRequest(QString name, QString surname, QString email, QString password)
{
    m_email = email;
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

void CppInterface::sendUserListRequest()
{
    QString request = RequestCreator::createUserListRequest();
    connection->sendRequest(request);
}

void CppInterface::sendMessageRequest(const int chat_id, const QString message_text)
{
    QString request = RequestCreator::createMessageRequest(chat_id, message_text);
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

    qDebug() << "Пришел ответ типа: " << answerType;

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
        emit sendChatListRequestCompleted(serverMessage);
    }
    else if(answerType == chatCreateCommand)
    {
        emit sendChatCreationRequestCompleted(serverMessage);
    }
    else if(answerType == chatRemoveCommand)
    {

    }
    else if(answerType == usersListCommand)
    {
        emit sendUserListRequestCompleted(serverMessage);
    }
    else if(answerType == sendMessageCommand)
    {
        emit sendMessageRequestCompleted(serverMessage);
    }
}

void CppInterface::setSignals()
{
    QObject::connect(connection, &ServerConnectorComponent::connectionStatusChanged,
                     this,       &CppInterface::connectionStatusChanged);
    QObject::connect(connection, &ServerConnectorComponent::serverMessage,
                     this,       &CppInterface::serverMessageRecieved);
}
