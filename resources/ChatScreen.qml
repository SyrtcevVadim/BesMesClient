import QtQuick 2.12
import QtQuick.Controls 2.15

Item {
    id: root
    visible: true

    Rectangle {
        id: menurect
        width: root.width > 600 ? root.width * 0.36 : root.width
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
            z: 1
        }

        ListView {
            id: listView
            anchors.top: titlescreen.bottom
            width: parent.width
            anchors.bottom: buttonmenu.top
            ScrollBar.vertical: ScrollBar{}

            delegate: ChatListItem {
                width: listView.width
            }
            model: 30
        }
// Добавить архив, чтобы хранить петабайты порнухи
//(с) Глава Департамента Разработки 03ПГ
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
