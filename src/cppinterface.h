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


    Q_INVOKABLE void connectToServer();
    Q_INVOKABLE void disconnectFromServer();
    Q_INVOKABLE void startApplication();

    Q_INVOKABLE void sendLoginRequest(QString email, QString password);
    Q_INVOKABLE void sendRegistrationRequest(QString name, QString surname, QString email, QString password);

signals:
    void serverStatusChanged(int statusCode);

    void loginRequestCompleted(int code);
    void registrationRequestCompleted(int code);
    void registrationCodeRequestCompleted(int code);

private slots:
    void connectionStatusChanged(bool status);
    void serverMessageRecieved(QString serverMessage);
private:
    void setSignals();
    ServerConnectorComponent *connection;

};

#endif // CPPINTERFACE_H
