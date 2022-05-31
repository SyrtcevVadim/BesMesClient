#ifndef CPPINTERFACE_H
#define CPPINTERFACE_H

#include <QObject>
#include <QQmlEngine>

#include "serverconnectorcomponent.h"
#include "requestcreator.h"

class CppInterface : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    CppInterface(QObject* parent = nullptr);
    ~CppInterface();

    Q_PROPERTY(QString email MEMBER m_email);
    Q_PROPERTY(int user_id MEMBER m_user_id);

    Q_INVOKABLE void connectToServer();
    Q_INVOKABLE void disconnectFromServer();

    Q_INVOKABLE void sendLoginRequest(QString email, QString password);
    Q_INVOKABLE void sendRegistrationRequest(QString name, QString surname, QString email, QString password);
    Q_INVOKABLE void sendChatCreationRequest(const QString name);
    Q_INVOKABLE void sendChatRemovingtRequest(const int chat_id);
    Q_INVOKABLE void sendChatListRequest();
    Q_INVOKABLE void sendUserListRequest();
    Q_INVOKABLE void sendMessageRequest(const int chat_id, const QString message_text);


signals:
    void serverStatusChanged(int statusCode);

    void loginRequestCompleted(int code);
    void registrationRequestCompleted(int code);
    void registrationCodeRequestCompleted(int code);

    void sendChatCreationRequestCompleted(const QString jsonAnswer);
    void sendChatRemovingtRequestCompleted(const int chat_id);
    void sendChatListRequestCompleted(const QString jsonAnswer);
    void sendUserListRequestCompleted(const QString jsonAnswer);
    void sendMessageRequestCompleted(const QString jsonAnswer);


private slots:
    void connectionStatusChanged(bool status);
    void serverMessageRecieved(QString serverMessage);
private:
    void setSignals();

    QString m_email;
    int m_user_id;
    ServerConnectorComponent *connection;
};

#endif // CPPINTERFACE_H
