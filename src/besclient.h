#ifndef BESCLIENT_H
#define BESCLIENT_H
#include "configreader.h"
#include "logsystem.h"
#include "BesProtocol.h"

#include <QObject>
#include <QSslSocket>
#include <QDebug>
#include <QSslError>

enum class RequestTarget
{
    None,
    Login,
    Registration,
    RegCode
};

class BesClient : public QObject
{
    Q_OBJECT
public:
    BesClient();
    ~BesClient();
    ///изменение адреса и порта сервера
    Q_INVOKABLE void reloadServerProperties(); //используется в экране разработчика
    ///выполнить подключение к серверу
    Q_INVOKABLE void connectToServer();     //имя connect занято, так что пишем длинное название
    ///отключится от сервера
    Q_INVOKABLE void disconnectFromServer();
    ///сделать запись в общий лог клиента
    Q_INVOKABLE void log(QString logString);

    ///данный метод исполняет запрос на получение данных с сервера типа requestType, используя данные, предоставленные в data\n
    ///запросы могут быть следующих типов:
    ///'login' - оправить запрос на авторизацию, массив data должен содержать данные для авторизации(логин в 0 элементе и пароль в 1 элементе)
    ///'registration' - запрос на авторизацию, массив data - 0 элемент - имя, 1 - фамилия, 2 - почта, 3 - пароль
    ///'regCode' - запрос на верификацию почты, в 0 элементе массива должен содержаться сам код
    Q_INVOKABLE void makeRequest(QString requestType, QVector<QString> data);

signals:
    ///сигнал издается при подключении к серверу
    void connected();
    ///сигнал издается при отключении от сервера
    void disconnected();
    ///сигнал издается при необходимости передать информацию от с++ клиента к QML
    void clientMessage(QString message, int errorCode, QVector<QVariant> additionalData);
private:
    ///сокет подключения к серверу
    QSslSocket *socket;
    ///текстовый поток ввода-вывода сокета
    QTextStream *out;
    ///адрес сервера
    QString serverAddress;
    ///порт сервера
    int serverPort;
    ///объект логирующей системы
    LogSystem *loggingSystem;
    ///сохраняет цель текущего обращения клиента к серверу для последующей обработки ответа
    RequestTarget target;
    ///если true, после разрыва соединения клиент попытается восстановить его
    bool keepConnected;
    ///объект, взаимодействующий с конфигами
    ConfigReader *config;

    ///первоначальное связывание сигналов и слотов
    void setSignals();

private slots:
    void socketConnected();
    void socketDisconnected();
    void readData();
    void messageLoggedResend(QString messageLogged);

    void setSocketSettings();
};

#endif // BESCLIENT_H
