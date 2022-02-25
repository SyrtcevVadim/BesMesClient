import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQml 2.15
import "main.js" as Functions


ApplicationWindow  {
    width: 800
    height: 600
    visible: true
    color: "#000000"
    title: "BesMesClient"
    id: mains

    Connections{
        target: BesClient
        function onConnected() {
            console.log("статус сервера - Подключен");
            serverScreen.serverStatus = "Подключен";
        }
        function onDisconnected() {
            console.log("статус сервера - Отключен");
            serverScreen.serverStatus = "Отключен";
        }
        function onClientMessage (messageStr, errorCode, additionalDataArray) {
            console.log(messageStr);
            switch(messageStr)
            {
            case "log":
                Functions.log(additionalDataArray[0]);
                break;

            default:
                mainStack.currentItem.getMessage(messageStr, errorCode, additionalDataArray);
                break;
            }
        }
    }
    NotificationManager{
        id: notifications
        window: mains
        anchors.right: parent.right
        anchors.top: parent.top
        ySpacing: 10
        width: 150
    }

    ChatScreen {
        id: startChat
        //anchors.fill: parent
        visible: false
    }

    StackView{
        id: mainStack
        anchors.fill: parent
        initialItem: startChat
    }
    WelcomeScreen {
        id: welcomeScreen
        visible: false
        onLoginButtonClicked: Functions.welcomeScreen_onLoginButtonClicked();
        onServerButtonClicked: mainStack.push(serverScreen)
        onRegButtonClicked: Functions.welcomeScreen_onRegButtonClicked();
    }
    ServerScreen {
        id: serverScreen
        visible: false
        onBackButtonClicked: mainStack.pop()
        onConnectButtonPressed: BesClient.connectToServer()
        onDisconnectButtonPressed: BesClient.disconnectFromServer()
        onReloadButtonPressed: BesClient.reloadServerProperties()
    }
}
