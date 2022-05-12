#include "cppinterface.h"
#include <QSettings>

CppInterface::CppInterface(QObject* parent) : QObject(parent)
{
    connection = new ServerConnectorComponent();
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

void CppInterface::sendRegistrationCodeRequest(QString registrationCode)
{
    QString request = RequestCreator::createVerificationRequest(registrationCode);
    connection->sendRequest(request);
}

void CppInterface::setSignals()
{

}
