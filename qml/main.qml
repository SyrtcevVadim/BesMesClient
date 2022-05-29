import QtQuick
import QtQuick.Controls
import com.test.object

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: "BesMes"
    id: appRoot

    Component.onCompleted: viewController.startApplication()

    menuBar: MenuBar {
        function getChatListActionReference() {return textChatListUpdate}

        Menu {
            title: "Test functions"
            Action {
                id: textChatListUpdate
                text: "Update chat list"
            }
        }
    }

    CppInterface{
        id: model
        onServerStatusChanged: (status) =>  console.log("статус сервера " + status)
    }

    Style{
        id: style
    }
    //элемент объединяющий в себе все функции обработки событий qml
    Controller{
        id: viewController
    }

    StackWindow{
        id: mainStack
        anchors.fill: parent
        focus: true
        initialItem: startScreen
//        initialItem: test
    }
    //статичные экраны, которые должны быть созданы во время запуска
    WelcomeScreen{
        id: startScreen
        maxContentWidth: 300
        isDebug: true
//        visible: false
        onLoginButtonClicked: viewController.createLoginScreen()
        onRegButtonClicked: viewController.createRegistrationScreen()
        onServerButtonClicked: viewController.openServerScreen()
    }
    ServerScreen{
        id: serverScreen
        visible: false
        onBackButtonClicked: mainStack.pop()
        onConnectButtonPressed: viewController.startApplication()
        onDisconnectButtonPressed: viewController.disconnectFromServer()
    }
    ChatScreen{
        id: test
    }
}
