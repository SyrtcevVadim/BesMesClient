import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQml 2.15

ApplicationWindow  {
    width: 640
    height: 480
    visible: true
    color: "#00000000"
    title: "BesMesClient"

    id: mains

    StackView{
        id: mainStack
        anchors.fill: parent
        initialItem: loginScreen
    }

    LoginScreen {
        id: loginScreen
        onLoginButtonClicked: Core.loginButtonClicked()
    }

}
