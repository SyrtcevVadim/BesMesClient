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
    Q_PROPERTY(QString test READ test CONSTANT)
public:
    CppInterface(QObject* parent = nullptr);
    ~CppInterface();

    QString test() {return _test;};

    Q_INVOKABLE void connectToServer();
    Q_INVOKABLE void disconnectFromServer();

    Q_INVOKABLE void sendLoginRequest(QString email, QString password);
    Q_INVOKABLE void sendRegistrationRequest(QString name, QString surname, QString email, QString password);
    Q_INVOKABLE void sendRegistrationCodeRequest(QString registrationCode);

signals:
    void serverStatusChanged(int statusCode);

    void loginRequestCompleted(int code);
    void registrationRequestCompleted(int code);
    void registrationCodeRequestCompleted(int code);

private:
    void setSignals();

    QString _test = "Привет из плюсов";
    ServerConnectorComponent *connection;
};

#endif // CPPINTERFACE_H
