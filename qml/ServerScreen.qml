import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQml
import JSConsole

Page{
    id: serverScreen

    signal backButtonClicked;
    signal connectButtonPressed;
    signal disconnectButtonPressed;
    signal reloadButtonPressed;

    property alias serverStatus: serverStatusText.text


    Button {
        id: button
        width: 40
        text: qsTr("<-")
        anchors.left: parent.left
        anchors.top: parent.top
        onClicked: function (mouse) {serverScreen.backButtonClicked()}
    }

    Text {
        id: pageNameText
        x: 47
        y: 62
        text: qsTr("Настройки сервера")
        font.pixelSize: 29
    }
    JSConsole {
        id: flickableTextArea
        property int sidemargin: parent.width * 0.1
        width: parent.width * 0.8
        anchors{
            top: pageNameText.bottom
            bottom: column.top
            horizontalCenter: parent.horizontalCenter
        }
    }
    Column {
        id: column
        y: 403
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        spacing: 5

        Text {
            id: serverStatusText
            text: qsTr("Отключен")
            anchors.left: parent.left
            font.pixelSize: 12
        }

        Row {
            id: row
            padding: 0
            spacing: 10

            RoundButton {
                id: connectButton
                text: "Connect"
                onClicked: function (mouse) {connectButtonPressed()}
            }

            RoundButton {
                id: disconnectButton
                text: "Disconnect"
                onClicked: function (mouse) {disconnectButtonPressed()}
            }

            RoundButton {
                id: reloadButton
                text: "reload config"
                onClicked: function (mouse) {reloadButtonPressed()}
            }
        }
    }
}
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1}D{i:2}D{i:3}D{i:5}D{i:6}D{i:4}
}
##^##*/
