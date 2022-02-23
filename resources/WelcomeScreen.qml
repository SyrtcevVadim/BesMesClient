import QtQuick 2.12
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQml 2.15

Page{
    id: welcomeScreen

    signal regButtonClicked;
    signal loginButtonClicked;
    signal serverButtonClicked;

    background: Rectangle{
        color: "#73FFC5"
        anchors.fill: welcomeScreen
    }

    Column{
        id: column
        anchors.centerIn: parent.Center
        width: parent.width < 300 ? parent.width : 300
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        padding: 0
        bottomPadding: 0
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: titleText
            width: parent.width
            text: qsTr("BesMes")
            font.pixelSize: 45
            horizontalAlignment: Text.AlignHCenter
        }

        RoundButton {
            id: loginButton
            width: parent.width
            text: "Войти"
            onClicked: function(mouse){welcomeScreen.loginButtonClicked()}
        }

        RoundButton {
            id: regButton
            width: parent.width
            text: "Регистрация"
            onClicked: function(mouse){welcomeScreen.regButtonClicked()}
        }

        RoundButton {
            id: serverButton
            width: parent.width
            text: "Настройки сервера"
            onClicked: function(mouse){welcomeScreen.serverButtonClicked()}
        }


    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:5}
}
##^##*/
