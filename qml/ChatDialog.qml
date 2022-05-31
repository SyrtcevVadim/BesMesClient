import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQml
import QtQml.Models

Item {
    id: root
    property alias backgroundColor: background.color
    property alias currentChatModel: messageList.model
    property alias currentText: messageInput.text
    property alias currentChatName: headerText.text

    signal sendMessageButtonClicked
    Rectangle {
        id: background
    }
    Rectangle {
        id: header
        z: 1
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        color: "#B0FFDE"
        height: 60
        Text {
            id: headerText
            anchors{
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
            width: parent.width - 50
            font.pixelSize: 35
        }
        Image {
            id: test
            source: "qrc:images/send_message_icon"
            anchors{
                right: parent.right
                rightMargin: 10
                top: parent.top
                topMargin: 20
                bottom: parent.bottom
                bottomMargin: 20
            }
            width: height
            MouseArea {
                anchors.fill: parent
                onClicked: (event) => {popupMenu.popup(event.x - popupMenu.width, event.y, popupMenu)}
            }

            Menu {
                id: popupMenu
                MenuItem {
                    text: "Удалить чат"
                }
                MenuItem {
                    text: "test2"
                }
            }
        }

    }

    ListView {
        id: messageList
        anchors.top: header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: footer.top
        //model: chatModel
        spacing: 10
        verticalLayoutDirection: ListView.BottomToTop
        delegate: Row {
            layoutDirection: isSender ? Qt.RightToLeft : Qt.LeftToRight
            width: messageList.width
            ChatDialogMessage {
                backgroundColor: isSender ? "#73FFC5" : "#EDFCF5"
                messageContent: message
                messageSenderName: name
                width: getWidth()
                function getWidth() {
                    var realWidth = contentWidth + 50
                    if (realWidth > root.width * 0.85) {
                        return root.width * 0.85
                    } else {
                        return realWidth
                    }
                }
            }
        }
    }
    Rectangle {
        id: footer
        z: 1
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        color: "#B0FFDE"
        height: 50
        TextField {
            id: messageInput
            background: Rectangle {
                radius: parent.height / 4
                border.width: 0
                color: "#edfcf5"
            }
            width: parent.width - 50
            font.pixelSize: 15
            placeholderText: "Введите сообщение"
            selectByMouse: true
            anchors {
                top: parent.top
                topMargin: 10
                bottom: parent.bottom
                bottomMargin: 10
                left: parent.left
                leftMargin: 5
            }
        }
        ImageButton {
            id: sendButton
            source_activated: "qrc:images/send_message_icon"
            source_deactivated: "qrc:images/send_message_icon"
            width: height

            onClicked: sendMessageButtonClicked()

            anchors {
                left: messageInput.right
                leftMargin: 10
                top: parent.top
                topMargin: 10
                bottom: parent.bottom
                bottomMargin: 10
            }
        }
    }
}
