import QtQuick
import QtQuick.Controls

Item {
    id: root
    visible: true
    onWidthChanged: checkState()
    state: "desktop"
    Component.onCompleted: initComponent()

    function initComponent() {
        checkState()
        controller.mainStack = ApplicationWindow.menuBar.getMainStackReference()
        controller.model = ApplicationWindow.menuBar.getModelReference()
        ApplicationWindow.menuBar.getChatListActionReference(
                    ).onTriggered.connect(getNewChatListModel)
        ApplicationWindow.menuBar.getChatMessageUpdateActionReference(
                    ).onTriggered.connect(onSelectedChatChanged)
        ApplicationWindow.menuBar.synchronizationActionReference(
                    ).onTriggered.connect(controller.synchronization)

        database.updateChatListModel(chatListModel)
    }
    function checkState() {
        if (root.width > 600) {
            root.state = "desktop"
        } else if (chatrect.chatActive) {
            root.state = "mobile-chat"
        } else {
            root.state = "mobile-menu"
        }
    }

    function getNewChatListModel() {
        let model = ApplicationWindow.menuBar.getModelReference()

        function callback() {
            root.updateChatListModel()
        }
        database.getChatList(model, callback)
    }

    function updateChatListModel()
    {
        chatListModel.clear()
        database.updateChatListModel(chatListModel)
    }

    function updateChatMessagesModel()
    {
        messagesModel.clear()
        let chatId = chatListModel.getCurrentChatId()
        database.updateDialogMessagesModel(messagesModel, chatId, controller.model)
    }

    function onSelectedChatChanged()
    {
        updateChatMessagesModel()
        chatrect.currentChatName = chatListModel.get(listView.currentIndex).name
    }

    Timer {
        interval: 500
        onTriggered: controller.synchronization()
    }

    states: [
        State {
            name: "desktop"
            PropertyChanges {
                target: menurect
                width: root.width * 0.36
                visible: true
            }
        },
        State {
            name: "mobile-menu"
            PropertyChanges {
                target: menurect
                width: root.width
                visible: true
            }
        },
        State {
            name: "mobile-chat"
            PropertyChanges {
                target: menurect
                width: 0
                visible: false
            }
        }
    ]

    Database {
        id: database
        onChatListUpdated: root.updateChatListModel()
    }

    ChatScreenController {
        id: controller
        mainStack: ApplicationWindow.menuBar.getMainStackReference()
        model: ApplicationWindow.menuBar.getModelReference()
    }

    Rectangle {
        id: menurect
        height: root.height
        z: 1
        color: "#B0FFDE"
        border.color: "#9AE4C2"
        border.width: 1

        Rectangle {
            id: titlescreen
            anchors.top: menurect.top
            anchors.left: menurect.left
            width: parent.width
            height: 60
            color: parent.color
            border.color: parent.border.color
            border.width: parent.border.width
            z: parent.z + 1
            Text {
                id: chatText
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    right: addButton.left
                }
                text: qsTr("Чаты")
                font.pixelSize: 26
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            ImageButton {
                id: addButton
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    topMargin: 10
                    bottomMargin: 10
                }
                width: height
                source_activated: "qrc:images/plus_icon_chat.png"
                source_deactivated: "qrc:images/plus_icon_chat.png"
                onClicked: controller.openAddNewChatScreen()
            }
        }

        ListView {
            id: listView
            anchors.top: titlescreen.bottom
            width: menurect.width
            anchors.bottom: buttonmenu.top
            ScrollBar.vertical: ScrollBar {}
            focus: true
            delegate: ChatListItem {
                width: listView.width
                chatName: model.name
                chatMessage: model.id
                isSelected: ListView.isCurrentItem
                MouseArea {
                    anchors.fill: parent
                    onClicked: listView.currentIndex = index
                }
            }
            onCurrentItemChanged: onSelectedChatChanged()
            model: chatListModel
        }

        ListModel {
            id: chatListModel
            function getCurrentChatId()
            {
                if(chatListModel.count === 0)
                    return 0;
                let chat_index = listView.currentIndex
                let chat_id = chatListModel.get(chat_index).id
                console.log(chat_id)
                return chat_id;
            }
        }
        Rectangle {
            id: buttonmenu
            anchors.bottom: parent.bottom
            height: 50
            width: parent.width
            anchors.left: parent.left
            color: parent.color

            Rectangle {
                id: leftButton
                anchors {
                    left: parent.left
                    top: parent.top
                }
                height: parent.height
                width: parent.width / 2
                color: parent.color

                ImageButton {
                    id: chatsButton
                    width: parent.height
                    height: parent.height
                    x: (parent.width - parent.height) / 2
                    source_activated: "qrc:images/chat_icon_activated.png"
                    source_deactivated: "qrc:images/chat_icon_deactivated.png"
                    onClicked: {
                        chatListModel.clear()
                        database.updateChatListModel(chatListModel)
                    }
                }
            }

            Rectangle {
                id: rightButton
                anchors {
                    right: parent.right
                    top: parent.top
                }
                height: parent.height
                width: parent.width / 2
                color: parent.color

                ImageButton {
                    width: parent.height - 10
                    height: parent.height - 10
                    x: (parent.width - parent.height + 10) / 2
                    y: 5
                    source_activated: "qrc:images/settings_icon_activated"
                    source_deactivated: "qrc:images/settings_icon_deactivated"
                    onClicked: {
                        database.testRecords(chatListModel)
                    }
                }
            }

            Rectangle {
                height: 1
                width: parent.width
                color: "#9AE4C2"
                anchors.top: parent.top
            }

            Rectangle {
                width: 1
                height: parent.height
                color: "#9AE4C2"
                anchors.right: parent.right
            }
        }
    }

    ChatDialog {
        id: chatrect
        anchors.left: menurect.right
        anchors.right: root.right
        anchors.top: root.top
        anchors.bottom: root.bottom
        backgroundColor: "#FFFFFF"
        currentChatModel: messagesModel

        currentChatName: "Название беседы"
        onSendMessageButtonClicked: controller.sendMessage(chatrect.currentText)
    }
    ListModel {
        id: messagesModel
        ListElement {
            name: "Владимир Воропаев"
            message: "Успеешь по срокам?"
            isSender: true
        }
        ListElement {
            name: "Екатерина Жужликова"
            message: "Постараюсь, но ничего не обещаю"
            isSender: false
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.5;height:480;width:640}D{i:6}D{i:7}D{i:10}D{i:5}
D{i:11}
}
##^##*/

