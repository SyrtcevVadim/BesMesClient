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

QString RequestCreator::createChatCreationRequest(const QString name)
{
    QJsonObject obj{
        {"тип_запроса", chatCreateCommand},
        {"название_чата", name}
    };
    QJsonDocument doc(obj);
    return QString::fromUtf8(doc.toJson());
}

QString RequestCreator::createChatRemovingtRequest(const int chat_id)
{
    QJsonObject obj{
        {"тип_запроса", chatRemoveCommand},
        {"id", chat_id}
    };
    QJsonDocument doc(obj);
    return QString::fromUtf8(doc.toJson());
}

QString RequestCreator::createChatListRequest()
{
    QJsonObject obj{
        {"тип_запроса", chatListCommand}
    };
    QJsonDocument doc(obj);
    return QString::fromUtf8(doc.toJson());
}

QString RequestCreator::createUserListRequest()
{
    QJsonObject obj{
        {"тип_запроса", usersListCommand}
    };
    QJsonDocument doc(obj);
    return QString::fromUtf8(doc.toJson());
}

QString RequestCreator::createMessageRequest(const int chat_id, const QString message_text)
{
    QJsonObject obj {
        {"тип_запроса", sendMessageCommand},
        {"ид_чата", chat_id},
        {"тело_сообщения", message_text}
    };
    QJsonDocument doc(obj);
    return QString::fromUtf8(doc.toJson());
}

QString RequestCreator::createSynchronizationRequest(const double timestamp)
{
    QJsonObject obj {
        {"тип_запроса", synchronizationCommand},
        {"временная_метка", timestamp}
    };
    QJsonDocument doc(obj);
    return QString::fromUtf8(doc.toJson());
}
