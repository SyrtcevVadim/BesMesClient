#ifndef REQUESTCREATOR_H
#define REQUESTCREATOR_H
#include <QString>
#include <QJsonDocument>
#include <QJsonObject>

namespace RequestCreator
{
    QString createLoginRequest(const QString email, const QString password);
    QString createRegistrationRequest(const QString name, const QString surname, const QString email, const QString password);
    QString createChatCreationRequest(const QString name);
    QString createChatRemovingtRequest(const int chat_id);
    QString createChatListRequest();
    QString createUserListRequest();

    const QString loginCommand {u"ЛОГИН"_qs};

    const QString registrationCommand {u"РЕГИСТРАЦИЯ"_qs};

    const QString usersListCommand {u"СПИСОКПОЛЬЗОВАТЕЛЕЙ"_qs};

    const QString chatListCommand {u"ЧАТЛИСТ"_qs};

    const QString unreadMesagesCommand {u"ЧАТСООБЩ"_qs};

    const QString sendMessageCommand {u"ОТПРСООБЩ"_qs};

    const QString chatCreateCommand {u"ЧАТСОЗДАТЬ"_qs};

    const QString chatRemoveCommand {u"ЧАТУДАЛ"_qs};
};


#endif // REQUESTCREATOR_H
