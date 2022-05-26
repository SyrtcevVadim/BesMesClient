import QtQuick
import QtQuick.Window
import QtQuick.Controls

StackView {
    property int maxContentWidth: 300

    function showWindow(header: string, text: string)
    {
        windowHeader.text = header
        windowContent.text = text
        rootItem.visible = true
    }

    Item {
        id: rootItem
        anchors.fill: parent
        visible: true
        z: 1
        Rectangle {
            opacity: 0.5
            color: "#FFFFFF"
            anchors.fill: parent
        }
        Rectangle {
            width: Math.min(parent.width, maxContentWidth)
            height: 200
            radius: 20
            anchors{
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            opacity: 1
            color: "#FFFFFF"
            border.color: "#000000"
            Text{
                id: windowHeader
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                font.pixelSize: 25
                horizontalAlignment: Text.AlignHCenter
                text: "Header"
            }
            Text{
                id: windowContent
                anchors{
                    top: windowHeader.bottom
                    left: parent.left
                    right: parent.right
                }
                font.pixelSize: 15
                horizontalAlignment: Text.AlignHCenter
                text: "test test test test test test test test test test"
            }
            RoundButton {
                id: button
                height: 35
                text: "Закрыть"
                anchors{
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    leftMargin: 5
                    rightMargin: 5
                    bottomMargin: 5
                }
                onClicked: rootItem.visible = false
            }
        }
    }
}
