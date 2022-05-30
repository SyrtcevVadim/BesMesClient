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

    const QString usersListCommand {u"СПИСОК_ПОЛЬЗОВАТЕЛЕЙ"_qs};

    const QString chatListCommand {u"СПИСОК_ЧАТОВ_ПОЛЬЗОВАТЕЛЯ"_qs};

    const QString unreadMesagesCommand {u"НЕПРОЧИТАННЫЕ_СООБЩЕНИЯ"_qs};

    const QString sendMessageCommand {u"ОТПРАВИТЬ_СООБЩЕНИЕ"_qs};

    const QString chatCreateCommand {u"СОЗДАТЬ_ЧАТ"_qs};

    const QString chatRemoveCommand {u"УДАЛИТЬ_ЧАТ"_qs};
};


#endif // REQUESTCREATOR_H
