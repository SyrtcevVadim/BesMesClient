import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQml 2.15
import "Functions.js" as Core

Page{
    id: loginScreen

    signal loginButtonClicked;

    background: Rectangle{
        color: "#73FFC5"
        anchors.fill: loginScreen
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
            onClicked: Core.loginButtonClicked()
        }

    }
}
