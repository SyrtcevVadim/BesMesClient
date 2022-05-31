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
        function getChatListActionReference() {
            return testChatListUpdate
        }
        function getChatMessageUpdateActionReference(){
            return testChatMessageUpdate
        }

        function getModelReference() {
            return model
        }
        function getMainStackReference() {
            return mainStack
        }
        Menu {
            title: "Test functions"
            Action {
                id: testChatListUpdate
                text: "Update chat list"
            }
            Action {
                id: testUserListUpdate
                text: "Update user list"
                onTriggered: database.getUsers(model)
            }
            Action {
                id: testChatMessageUpdate
                text: "Update current chat"
            }
        }
        Menu {
            title: "База данных"
            Action {
                id: databaseCreate
                text: "Создать базу данных"
                onTriggered: database.createDatabase()
            }
            Action {
                id: databaseDrop
                text: "Удалить базу данных"
                onTriggered: database.dropDatabase()
            }
            Action {
                text: "Вывести таблицу chat"
                onTriggered: database.getTableChat()
            }
            Action {
                text: "Вывести таблицу user"
                onTriggered: database.getTableUser()
            }
            Action {
                text: "Вывести таблицу messages"
                onTriggered: database.getTableMessages()
            }

        }
        Menu {
            title: "Подключение"
            Action {
                text: "Подключится к серверу"
                onTriggered: model.connectToServer()
            }
        }
    }

    Database {
        id: database
    }

    CppInterface {
        id: model
        onServerStatusChanged: status => console.log("статус сервера " + status)
    }

    Style {
        id: style
    }
    //элемент объединяющий в себе все функции обработки событий qml
    Controller {
        id: viewController
    }

    StackWindow {
        id: mainStack
        anchors.fill: parent
        focus: true
        initialItem: startScreen
    }
    //статичные экраны, которые должны быть созданы во время запуска
    WelcomeScreen {
        id: startScreen
        maxContentWidth: 300
        isDebug: true
        visible: false
        onLoginButtonClicked: viewController.createLoginScreen()
        onRegButtonClicked: viewController.createRegistrationScreen()
        onServerButtonClicked: viewController.openServerScreen()
    }
    ServerScreen {
        id: serverScreen
        visible: false
        onBackButtonClicked: mainStack.pop()
        onConnectButtonPressed: viewController.startApplication()
        onDisconnectButtonPressed: viewController.disconnectFromServer()
    }

    //ChatScreen { }
    function getControllerReference() {
        return viewController
    }
}
