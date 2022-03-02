import QtQuick 2.0

Item {
    id: rootitem
    width: 200
    height: 60

    property alias chatName: nameChat.text
    property alias chatMessage: messageChat.text

    signal clicked;

    MouseArea{
        onClicked: {
            rootitem.clicked();
        }
        anchors.fill: parent;
    }

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
        color: Qt.rgba(Math.random(),Math.random(),Math.random(),1) //"red"
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
