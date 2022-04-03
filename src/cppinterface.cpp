#include "cppinterface.h"
#include <QSettings>

CppInterface::CppInterface(QObject* parent) : QObject(parent)
{
}

CppInterface::~CppInterface()
{
    delete connection;
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
