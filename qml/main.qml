import QtQuick
import QtQuick.Controls
import com.test.object

Window {
    width: 800
    height: 600
    visible: true
    title: "BesMes"
    id: appRoot

    CppInterface{
        id: test
    }

    Style{
        id: style
    }
    //элемент объединяющий в себе все функции обработки событий qml
    Controller{
        id: viewController
    }
    StackView{
        id: mainStack
        anchors.fill: parent
        initialItem: startScreen
    }

    //статичные экраны, которые должны быть созданы во время запуска
    WelcomeScreen{
        id: startScreen
        maxContentWidth: 300
        isDebug: true
        onLoginButtonClicked: viewController.createLoginScreen()
        onRegButtonClicked: viewController.createRegistrationScreen()
        onServerButtonClicked: viewController.openServerScreen()
    }
    ServerScreen{
        id: serverScreen
        visible: false
        onBackButtonClicked: mainStack.pop()
    }
}
