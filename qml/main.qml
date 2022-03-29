import QtQuick
import QtQuick.Controls

Window {
    width: 800
    height: 600
    visible: true
    title: "BesMes"
    id: appRoot

    Style{
        id: style
    }
    Controller{
        id: viewController
    }
    StackView{
        id: mainStack
        anchors.fill: parent
        initialItem: startScreen
    }

    WelcomeScreen{
        id: startScreen
        maxContentWidth: 300
        isDebug: true

        onRegButtonClicked: viewController.createRegistrationScreen()
        onServerButtonClicked: viewController.openServerScreen()
    }
    ServerScreen{
        id: serverScreen
        visible: false
        onBackButtonClicked: mainStack.pop()
    }
}
