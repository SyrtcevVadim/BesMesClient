#include "requestcreator.h"

QString RequestCreator::createLoginRequest(const QString email, const QString password)
{
    return QString("%1 %2 %3\r\n").arg(loginCommand, email, password);
}

QString RequestCreator::createRegistrationRequest(const QString name, const QString surname, const QString email, const QString password)
{
    return QString("%1 %2 %3 %4 %5\r\n").arg(registrationCommand, name, surname, email, password);
}

QString RequestCreator::createVerificationRequest(const QString code)
{
    return QString("%1 %2\r\n").arg(verificationCommand, code);
}
