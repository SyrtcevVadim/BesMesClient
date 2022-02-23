import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQml 2.15

Page{
    id: serverScreen
    signal backButtonClicked;

    signal connectButtonPressed;
    signal disconnectButtonPressed;
    signal reloadButtonPressed;

    property alias serverStatus: serverStatusText.text
    property alias logTextAreaText: logText.text


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
    Flickable {
        id: flickabelTextArea
        anchors.top: pageNameText.bottom
        anchors.bottom: column.top
        flickableDirection: Flickable.VerticalFlick

        anchors.bottomMargin: 0
        property int sidemargin: parent.width * 0.1
        anchors.rightMargin: sidemargin
        anchors.leftMargin: sidemargin
        anchors.left: parent.left
        anchors.right: parent.right
        TextArea.flickable: TextArea {
            id: logText
            text: ""
            readOnly: true
            wrapMode: TextArea.Wrap
            anchors.topMargin: -6
            background: Rectangle {
                border.width: 1
                border.color: "black"
            }
        }
        ScrollBar.vertical: ScrollBar { }
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
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
