#ifndef SERVERCONNECTORCOMPONENT_H
#define SERVERCONNECTORCOMPONENT_H

#include <QObject>
#include <QWebSocket>
#include <QSslConfiguration>

#include "settingsreader.h"

class ServerConnectorComponent : public QObject
{
    Q_OBJECT
public:
    enum class RequestType{
        Login,
        Registration,
        RegistrationCode
    };


    // осуществляет попытку подключения к серверу, по ее окончании издает сигнал connectionStatusChanged
    void connect();
    // отключение от сервера
    void disconnect();


    // оправка сформированного запроса на сервер
    void sendRequest(QString requestString);

    void reloadServerSettings();
    ServerConnectorComponent();

signals:
    void connectionStatusChanged(bool isConnected);
private slots:
    void onSocketConnected();
    void onSocketDisconnected();

    void onTextMessageRecieved(const QString &message);

private:
    void setSocketSettings();
    void setSignals();

    QWebSocket *socket;
    //настройки подключения
    QString serverAddress;
    int serverPort;

    bool keepConnection;
    SettingsReader *settings;
};

#endif // SERVERCONNECTORCOMPONENT_H
