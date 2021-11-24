import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQml 2.15

Page{
    id: registrationScreen
    signal backButtonClicked;
    signal regButtonClicked;

    property alias nameText: nameTextField.text
    property alias surnameText: surnameTextField.text
    property alias emailText: emailTextField.text
    property alias passwordText: passTextField.text

    background: Rectangle{
        anchors.fill: loginScreen
        color: "white"
    }
    Text{
        text: "Регистрация"
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
        columns: 2
        Text{
            id: nameText
            text: "Имя"
            height: passTextField.height
            font.pixelSize: height * 0.5
            verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: nameTextField
            bottomInset: 0
            placeholderText: "Введите имя"
            selectByMouse: true
        }
        Text{
            id: surnameText
            text: "Фамилия"
            height: passTextField.height
            font.pixelSize: height * 0.5
            verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: surnameTextField
            bottomInset: 0
            placeholderText: "Введите фамилие"
            selectByMouse: true
        }

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
        text: "Зарегистрироваться"
        anchors.top: grid.bottom
        font.pixelSize: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 25
        onClicked: function (mouse){regButtonClicked()}
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
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
