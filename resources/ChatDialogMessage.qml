import QtQuick 2.15

Item{
    id: root
    width: 200
    height: messageSenderName.height + messageContent.height + 15
    property alias messageSenderName: messageSenderName.text
    property alias messageContent: messageContent.text
    property alias backgroundColor: background.color

    Rectangle{
        id: background
        color: "#ffffff"
        radius: 25
        anchors.fill: parent
    }
    Text{
        id: messageSenderName
        text: "Владимир Воропаев"
        anchors.left: parent.left
        anchors.top: root.top
        font.pointSize: 10
        anchors.topMargin: 5
        anchors.leftMargin: 20
    }
    Text{
        id: messageContent
        text: "Пошел ты нахуй со своим проектом ебаклак"
        elide: Text.ElideNone
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: root.bottom
        wrapMode: Text.WordWrap
        anchors.rightMargin: 0
        anchors.bottomMargin: 5
        anchors.leftMargin: 20
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.75}D{i:1}D{i:2}D{i:3}
}
##^##*/
