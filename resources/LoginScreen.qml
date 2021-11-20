import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQml 2.15

Page{
    id: loginScreen
    signal backButtonClicked;
    signal loginButtonClicked;

    property alias loginText: emailTextField.text
    property alias passwordText: passTextField.text

    background: Rectangle{
        anchors.fill: loginScreen
        color: "white"
    }
    Text{
        text: "Вход"
        anchors.left: grid.left
        anchors.bottom: grid.top
        font.pixelSize: 35
        anchors.leftMargin: -37
        anchors.bottomMargin: 24

    }

    Grid {
        id: grid
        anchors.verticalCenter: parent.verticalCenter
        spacing: 25
        anchors.horizontalCenter: parent.horizontalCenter
        rows: 2
        columns: 2

        Text{
            id: emailText
            height: emailTextField.height
            text: "Почта"
            font.pixelSize: height * 0.5
            verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: emailTextField
            placeholderText: "Введите почту"
            selectByMouse: true
        }

        Text{
            id: passText
            text: "Пароль"
            height: passTextField.height
            font.pixelSize: height * 0.5
            verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: passTextField
            bottomInset: 0
            placeholderText: "Введите пароль"
            selectByMouse: true
        }
    }

    RoundButton {
        id: roundButton
        width: grid.width * 0.66
        text: "Войти"
        anchors.top: grid.bottom
        font.pixelSize: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 25
        onClicked: function (mouse){loginButtonClicked()}
    }

    Button {
        id: button
        width: 40
        text: qsTr("<-")
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.topMargin: 0
        onClicked: function(mouse){loginScreen.backButtonClicked()}
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:9}
}
##^##*/
