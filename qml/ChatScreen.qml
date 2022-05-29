import QtQuick
import QtQuick.Controls

Item {
    id: root
    visible: true
    onWidthChanged: checkState()
    state: "desktop"
    Component.onCompleted: initComponent()

    function initComponent()
    {
        checkState()
        ApplicationWindow.menuBar.getChatListActionReference().onTriggered.connect(updateChatListModel)
    }
    function checkState()
    {
        if(root.width > 600){
            root.state = "desktop"
        }
        else if(chatrect.chatActive)
        {
            root.state = "mobile-chat"
        }
        else{
            root.state = "mobile-menu"
        }
    }

    function updateChatListModel()
    {
        database.updateChatListModel(chatListModel)
    }

    states: [
        State{
            name: "desktop"
            PropertyChanges {
                target: menurect;
                width: root.width * 0.36
                visible: true
            }
        },
        State{
            name: "mobile-menu"
            PropertyChanges {
                target: menurect
                width: root.width
                visible: true
            }
        },
        State{
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
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            ImageButton{
                id: addButton
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                width: height
                source_activated: "qrc:images/chat_add.png"
                source_deactivated: "qrc:images/chat_add.png"
                onClicked:{
                    database.updateChatListModel(chatListModel)
                }
            }
        }

        ListView {
            id: listView
            anchors.top: titlescreen.bottom
            width: menurect.width
            anchors.bottom: buttonmenu.top
            ScrollBar.vertical: ScrollBar{}
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
            model: chatListModel
        }

        ListModel {
            id: chatListModel
        }

// Добавить архив, чтобы хранить петабайты порнухи
//(с) Глава Департамента Разработки 03ПГ
        Rectangle {
            id: buttonmenu
            anchors.bottom: parent.bottom
            height: 50
            width: parent.width
            anchors.left: parent.left
            color: parent.color
            border.color: parent.border.color
            border.width: parent.border.width
            Row {
                anchors.fill: parent
                ImageButton{
                    id: chatsButton
                    source_activated: "qrc:images/chat_icon_activated.png"
                    source_deactivated: "qrc:images/chat_icon_deactivated.png"
                    onClicked: {
                        chatListModel.clear()
                        database.updateChatListModel(chatListModel)
                    }
                }
                ImageButton{
                    source_activated: "qrc:images/settings_icon_activated"
                    source_deactivated: "qrc:images/settings_icon_deactivated"
                    onClicked: {
                        database.testRecords(chatListModel)
                    }
                }
            }
        }
    }

    ChatDialog {
        id: chatrect
        property bool chatActive: true
        anchors.left: menurect.right
        anchors.right: root.right
        anchors.top: root.top
        anchors.bottom: root.bottom
        backgroundColor: "#FFFFFF"
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.5;height:480;width:640}D{i:6}D{i:7}D{i:10}D{i:5}
D{i:11}
}
##^##*/
