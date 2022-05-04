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

}

void CppInterface::disconnectFromServer()
{

}

void CppInterface::sendLoginRequest(QString email, QString password)
{

}

void CppInterface::sendRegistrationRequest(QString name, QString surname, QString email, QString password)
{

}

void CppInterface::sendRegistrationCodeRequest(QString registrationCode)
{

}
