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
        height: 50
        Text {
            id: headerText
            anchors{
                top: parent.top
                left: parent.left
                bottom: parent.bottom
                leftMargin: 10
            }
            verticalAlignment: Text.AlignVCenter
            width: parent.width - 50
            font.pixelSize: 26
        }
        Image {
            id: test
            source: "qrc:images/menu_vertical.png"
            anchors{
                right: parent.right
//                rightMargin: 10
                top: parent.top
                topMargin: 7
                bottom: parent.bottom
                bottomMargin: 7
            }
            width: height
            MouseArea {
                anchors.fill: parent
                onClicked: (event) => {popupMenu.popup(event.x - popupMenu.width, event.y, popupMenu)}
            }

            Menu {
                id: popupMenu
                MenuItem {
                    text: "Настройки чата"

                    onClicked: popup.open()

                    Popup{
                        id: popup
                        parent: Overlay.overlay

                        x :Math.round((parent.width - width) / 2)
                        y :Math.round((parent.height - height) / 2)
                        width: 300
                        height: 400

                        padding: 1

                        Rectangle{
                            id:settingsRect
                            color: "#73FFC4"
                            height: 60
                            width: parent.width
                            anchors{
                                top: parent.top
                                left: parent.left
                            }
                            Rectangle{
                                id: settingsRectTitle
                                height: parent.height
                                anchors{
                                    top: parent.top
                                    left: parent.left
                                    right: cancel_image.left
                                    leftMargin: 10
                                }
                                color: parent.color

                                Text{
                                    id: chat_name_popup
                                    width: parent.width
                                    anchors{
                                        top: parent.top
                                        left: parent.left
                                        topMargin: 7
                                    }
                                    text: qsTr("Название чата Название чата Название чата")
                                    font.pixelSize: 18
                                    elide: Text.ElideRight
                                }

                                Text{
                                    width: parent.width
                                    anchors{
                                        top: chat_name_popup.bottom
                                        left: parent.left
                                    }
                                    text: qsTr("3 участника")
                                    font.pixelSize: 14
                                }
                            }


                            Image {
                                id: cancel_image
                                height: parent.height - 34
                                width: 26
                                anchors{
                                    top: parent.top
                                    right: parent.right
                                    topMargin: 17
                                    rightMargin: 17
                                }

                                source: "qrc:images/cancel_icon.png"
                            }

                            Rectangle{
                                height: 2
                                color: "lightgray"
                                width: parent.width
                                anchors{
                                    bottom: settingsRectTitle.bottom
                                    right: parent.right
                                }
                            }
                        }

                        Rectangle{
                            id: addUserChat
                            height: 50
                            width: parent.width
                            anchors{
                                top: settingsRect.bottom
                                right: parent.right
                            }

                            Image {
                                id: addChatImg
                                height: parent.height - 20
                                width: height
                                anchors{
                                    top: parent.top
                                    left: parent.left
                                    leftMargin: 10
                                    topMargin: 10
                                }

                                source: "qrc:images/plus_icon_chat.png"
                            }
                            Text{
                                height: parent.height
                                anchors{
                                    left: addChatImg.right
                                    top: parent.top
                                }
                                text: "Добавить участника"
                                font.pixelSize: 14
                                verticalAlignment: Text.AlignVCenter
                            }

                            Rectangle{
                                height: 2
                                color: "lightgray"
                                width: parent.width
                                anchors{
                                    bottom: addUserChat.bottom
                                    right: parent.right
                                }
                            }
                        }

                        ListView{
                            id: userChatList
                            anchors{
                                top: addUserChat.bottom
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                            }

                            delegate: Row{
                            width: parent.width
                            height: 40

                            Rectangle{
                                id: userChatIcon
                                height: parent.height - 10
                                width: height
                                anchors{
                                    top: parent.top
                                    topMargin: 5
                                    left: parent.left
                                    leftMargin: 5
                                }

                                radius: width/2
                                border{
                                    color: "gray"
                                    width: 1
                                }
                                color: Qt.rgba(Math.random(),Math.random(),Math.random(),1)
                            }

                            Text{
                                id: userChatItem
                                height: parent.height
                                anchors{
                                    top: parent.top
                                    left: userChatIcon.right
                                    right: parent.right
                                    leftMargin: 10
                                }

                                text: "Пользователь такой-то"
                                font.pixelSize: 14
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                            }

                            Rectangle{
                                height: 1
                                width: parent.width
                                color: "lightgray"
                                anchors{
                                    bottom: parent.bottom
                                    left: parent.left
                                }
                            }

                        }

                            model: 5
                        }
                    }


                }
                MenuItem {
                    text: "Выйти из чата"
                }
            }
        }


        Rectangle{
            height: 1
            width: parent.width
            color: "#9AE4C2"
            anchors.bottom: parent.bottom
        }


    }

    ListView {
        id: messageList
        anchors{
            top: header.bottom
            left: root.left
            right: root.right
            bottom: footer.top
            margins: 5
        }
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
                radius: parent.height / 2
                border.width: 0
                color: "#edfcf5"
            }
            width: parent.width - 50
            font.pixelSize: 15
            placeholderText: "Введите сообщение"
            selectByMouse: true
            leftPadding: 10
            rightPadding: 10
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

        Rectangle{
            height: 1
            width: parent.width
            color: "#9AE4C2"
            anchors.top: parent.top
        }
    }
}
