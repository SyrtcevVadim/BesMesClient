import QtQuick 2.0

Item {
    id: rootitem
    width: 200
    height: 60

    Rectangle {
        id: icon

        anchors {
            top: parent.top
            topMargin: 5
            left: parent.left
            leftMargin: 5

        }

        width: rootitem.height - 10
        height: width
        radius: width/2
        border.color: "black" //цвет обводки
        border.width: 2 //ширина обводки
        color: "red"
    }

    Text {
        id: nameChat
        anchors {
            top: parent.top
            topMargin: 5
            left: icon.right
            leftMargin: 10
            right: parent.right
        }
        text: "namenamenamenamename"   /*name*/
        font.bold: true
        elide: Text.ElideRight
    }

    Text {
        id: messageChat
        anchors {
            top: nameChat.bottom
            topMargin: 5
            left: icon.right
            leftMargin: 10
            right: parent.right
        }
        text: "texttexttexttexttexttexttexttexttext"
        elide: Text.ElideRight
    }
}
