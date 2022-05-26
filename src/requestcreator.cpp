#include "requestcreator.h"

QString RequestCreator::createLoginRequest(const QString email, const QString password)
{
    QJsonObject obj{
        {"тип_запроса", loginCommand},
        {"почта", email},
        {"пароль", password}
    };
    QJsonDocument doc(obj);
    return QString::fromUtf8(doc.toJson());
}

QString RequestCreator::createRegistrationRequest(const QString name, const QString surname, const QString email, const QString password)
{
    QJsonObject obj{
        {"тип_запроса", registrationCommand},
        {"имя", name},
        {"фамилия", surname},
        {"почта", email},
        {"пароль", password}
    };
    QJsonDocument doc(obj);
    return QString::fromUtf8(doc.toJson());
}
