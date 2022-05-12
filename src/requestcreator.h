#ifndef REQUESTCREATOR_H
#define REQUESTCREATOR_H
#include <QString>

namespace RequestCreator
{
    QString createLoginRequest(const QString email, const QString password);
    QString createRegistrationRequest(const QString name, const QString surname, const QString email, const QString password);
    QString createVerificationRequest(const QString code);

    const QString loginCommand {u"ПРИВЕТ"_qs};

    const QString registrationCommand {u"РЕГИСТРАЦИЯ"_qs};

    const QString verificationCommand {u"КОДРЕГ"_qs};
};


#endif // REQUESTCREATOR_H
