import QtQuick 2.0

Item {
    id: root
    visible: true

    Rectangle {
        id: menurect
        x: 0
        y: 0
        width: root.width / 3
        height: root.height

        color: "#B0FFDE"
        border.color: "#9AE4C2"
        border.width: 2

        Rectangle {
            id: titlescreen
            anchors.top: menurect.top
            anchors.left: menurect.left
            width: parent.width
            height: 60
            color: parent.color
            border.color: parent.border.color
            border.width: parent.border.width
        }

        ListView {
            id: listView
            anchors.top: titlescreen.bottom
            width: parent.width
            anchors.bottom: buttonmenu.top

            delegate: ChatListItem {
                width: listView.width
            }
            model: 15
        }

        Rectangle {
            id: buttonmenu
            anchors.bottom: parent.bottom
            height: 60
            width: parent.width
            anchors.left: parent.left
            color: parent.color
            border.color: parent.border.color
            border.width: parent.border.width
        }
    }

    Rectangle {
        id: chatrect
        width: root.width - menurect.width
        height: root.height
        anchors.left: menurect.right
        border.color: "#9AE4C2"
        border.width: 2
    }
}
