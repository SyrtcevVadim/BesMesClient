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
        function onMessageLogged (message) {Core.log(message)}
        function onClientMessage (messageStr, errorCode, additionalDataArray) {
            switch(messageStr)
            {
            case "messageLogged":
                Core.log(additionalDataArray[0]);
                break;

            default:
                mainStack.currentItem.getMessage(messageStr, errorCode, additionalDataArray);
                break;
            }
        }
    }
    StackView{
        id: mainStack
        anchors.fill: parent
        initialItem: welcomeScreen
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
