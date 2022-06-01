import QtQuick

Item {
    id: rootitem
    width: 200
    height: 60

    property alias chatName: nameChat.text
    property alias chatMessage: messageChat.text
    property bool isSelected: false

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
        z: parent.z
        width: rootitem.height - 10
        height: width
        radius: width/2
        border.color: "gray" //цвет обводки
        border.width: 1 //ширина обводки
        color: Qt.rgba(Math.random(),Math.random(),Math.random(),1) //"red"
    }

    Text {
        id: nameChat
        z: parent.z
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
        z: parent.z
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

    Rectangle {
        anchors.fill: parent
        z: parent.z-1
        color: "#73FFC4"
        visible: isSelected
    }

    Rectangle {
        height: 1
        z: parent.z
        color: "#9AE4C2"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
