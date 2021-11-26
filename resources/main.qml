import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQml 2.15
import "Functions.js" as Core

ApplicationWindow  {
    width: 640
    height: 480
    visible: true
    color: "#00000000"
    title: "BesMesClient"

    id: mains
    Connections{
        target: BesClient
        function onConnected() {Core.changeServerStatus(true)}
        function onDisconnected() {Core.changeServerStatus(false)}
        function onMessageLogged(message) {Core.log(message)}
    }
    StackView{
        id: mainStack
        anchors.fill: parent
        initialItem: welcomeScreen
    }
    WelcomeScreen {
        id: welcomeScreen
        visible: false
        onLoginButtonClicked: Core.loginButtonClicked()
        onServerButtonClicked: mainStack.push(serverScreen)
        onRegButtonClicked: Core.registrationButtonClicked();
    }
    ServerScreen {
        id: serverScreen
        visible: false
        onSettingsChanged: Core.settingsChanged()
        onBackButtonClicked: mainStack.pop()
        onConnectButtonPressed: BesClient.connectToServer()
        onDisconnectButtonPressed: BesClient.disconnectFromServer()
        onReloadButtonPressed: BesClient.reloadServerProperties()
    }
}
