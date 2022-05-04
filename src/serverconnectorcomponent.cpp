#include "serverconnectorcomponent.h"

ServerConnectorComponent::ServerConnectorComponent() : QObject(nullptr)
{
    settings = new SettingsReader();
    socket = new QWebSocket();
    setSocketSettings();
}

void ServerConnectorComponent::onSocketConnected()
{
    //emit connectionStatusChanged(true);
}

void ServerConnectorComponent::onSocketDisconnected()
{

}

void ServerConnectorComponent::onReadyRead()
{

}

void ServerConnectorComponent::setSignals()
{

}

void ServerConnectorComponent::setSocketSettings()
{
    QSslConfiguration sslConfig;
    sslConfig.setPeerVerifyMode(QSslSocket::PeerVerifyMode::QueryPeer);
    socket->setSslConfiguration(sslConfig);

    serverAddress = settings->getServerAddress();
    serverPort = settings->getServerPort();

    socket->ignoreSslErrors();
}

void ServerConnectorComponent::connect()
{

}

void ServerConnectorComponent::disconnect()
{

}

void ServerConnectorComponent::sendRequest(QString requestString)
{

}

bool ServerConnectorComponent::reloadServerSettings()
{

}
