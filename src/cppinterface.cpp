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

void CppInterface::connectionStatusChanged(bool status)
{
    emit serverStatusChanged((int)status);
}

void CppInterface::serverMessageRecieved(QString serverMessage)
{

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

}
