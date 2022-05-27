#include "serverconnectorcomponent.h"
#include <QJsonDocument>
#include <QAbstractSocket>

ServerConnectorComponent::ServerConnectorComponent() : QObject(nullptr)
{
    settings = new SettingsReader();
    socket = new QSslSocket();
    setSignals();
    setSocketSettings();
}

ServerConnectorComponent::~ServerConnectorComponent()
{
    disconnect();
    delete socket;
    delete settings;
}

void ServerConnectorComponent::onSocketConnected()
{
    emit connectionStatusChanged(true);
    qDebug() << "connected";
}

void ServerConnectorComponent::onSocketDisconnected()
{
    emit connectionStatusChanged(false);
    qDebug() << "disconnected";
    qDebug() << socket->sslHandshakeErrors().length();
}

void ServerConnectorComponent::onReadyRead()
{
    static QString data = "";
    QString dataPart = QString::fromUtf8(socket->readAll());
    data += dataPart;
    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8(), &error);
    qDebug() << "получили пакет " << data;
    if(!doc.isNull())
    {
        emit serverMessage(data);
        data = "";
    }
}

void ServerConnectorComponent::setSignals()
{
    QObject::connect(socket, &QSslSocket::readyRead,
                     this, &ServerConnectorComponent::onReadyRead);
    QObject::connect(socket, &QSslSocket::encrypted,
                     this, &ServerConnectorComponent::onSocketConnected);
    QObject::connect(socket, &QSslSocket::disconnected,
                     this, &ServerConnectorComponent::onSocketDisconnected);
    QObject::connect(socket, QOverload<const QList<QSslError> &> :: of(&QSslSocket::sslErrors),
        [=](const QList<QSslError> &errors){
            for(const QSslError &a : errors)
            {
                qDebug() << a;
            }
        }
    );
    QObject::connect(socket, &QSslSocket::errorOccurred,
                     this,   &ServerConnectorComponent::test);
}

void ServerConnectorComponent::test(QAbstractSocket::SocketError socketError)
{
    qDebug() << "error: " << socketError;
}

void ServerConnectorComponent::setSocketSettings()
{
    QSslConfiguration sslConfig;
    sslConfig.setPeerVerifyMode(QSslSocket::PeerVerifyMode::VerifyNone);
    sslConfig.setProtocol(QSsl::TlsV1_2);
    socket->setSslConfiguration(sslConfig);

    serverAddress = settings->getServerAddress();
    serverPort = settings->getServerPort();

    socket->ignoreSslErrors();
}

void ServerConnectorComponent::connect()
{
    qDebug() << QString("Подключаемся по адресу %1:%2").arg(serverAddress).arg(serverPort);
    socket->connectToHostEncrypted(serverAddress, serverPort);
}

void ServerConnectorComponent::disconnect()
{
    socket->close();
}

void ServerConnectorComponent::sendRequest(QString requestString)
{
    qDebug() << requestString;
    socket->write(requestString.toUtf8());
    //QTextStream out(socket);
    //out << requestString;
}

void ServerConnectorComponent::reloadServerSettings()
{
    serverAddress = settings->getServerAddress();
    serverPort = settings->getServerPort();
}
