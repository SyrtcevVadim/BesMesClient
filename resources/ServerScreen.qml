import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQml 2.15

Page{
    id: serverScreen
    signal backButtonClicked;
    signal settingsChanged;

    signal connectButtonPressed;
    signal disconnectButtonPressed;

    property alias serverAdress: adressField.text
    property alias serverPort: portField.text

    property alias serverStatus: serverStatusText.text

    Grid {
        id: grid
        anchors.verticalCenter: parent.verticalCenter
        spacing: 15
        columns: 2
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: text1
            height: adressField.height
            text: qsTr("Адрес сервера")
            font.pixelSize: height * 0.5
            verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: adressField
            placeholderText: qsTr("Text Field")
            onTextChanged: function() {serverScreen.settingsChanged()}
        }

        Text {
            id: text2
            height: portField.height
            text: qsTr("Порт")
            font.pixelSize: height * 0.5
            verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: portField
            placeholderText: qsTr("Text Field")
            onTextChanged: function() {serverScreen.settingsChanged()}
        }
    }

    Button {
        id: button
        width: 40
        text: qsTr("<-")
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.topMargin: 0
        onClicked: function (mouse) {serverScreen.backButtonClicked()}
    }

    Text {
        id: text3
        y: 111
        text: qsTr("Настройки сервера")
        anchors.left: grid.left
        anchors.bottom: grid.top
        font.pixelSize: 29
        anchors.leftMargin: -72
        anchors.bottomMargin: 28
    }

    Column {
        id: column
        y: 373
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 0

        Text {
            id: serverStatusText
            text: qsTr("Отключен")
            anchors.left: parent.left
            font.pixelSize: 12
            anchors.leftMargin: 0
        }

        Row {
            id: row

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
        }

    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:7}D{i:8}
}
##^##*/
