import QtQuick
import QtQuick.Window
import QtQuick.Controls
Page{
    id: root

    property int maxContentWidth: 300
    property bool isDebug: false

    signal regButtonClicked;
    signal loginButtonClicked;
    signal serverButtonClicked;

    background: Rectangle{
        color: "#73FFC5"
    }

    Column{
        id: column

        spacing: 10

        anchors{
            centerIn: parent.Center
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        width: {
            if(parent.width < maxContentWidth){
                parent.width
            }
            else{
                maxContentWidth
            }
        }

        Text {
            width: parent.width
            text: qsTr("BesMes")
            font.pixelSize: 45
            horizontalAlignment: Text.AlignHCenter
        }
        RoundButton {
            width: parent.width
            text: qsTr("Войти")
            onClicked: root.loginButtonClicked()
        }
        RoundButton {
            width: parent.width
            text: qsTr("Регистрация")
            onClicked: root.regButtonClicked()
        }
        RoundButton {
            width: parent.width
            text: qsTr("Настройки сервера")
            onClicked: root.serverButtonClicked()
            visible: isDebug
        }
    }
}
