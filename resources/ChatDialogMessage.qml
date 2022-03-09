import QtQuick 2.15

Item{
    id: root
    height: messageSenderName.height + messageContent.height + 15
    property alias messageSenderName: messageSenderName.text
    property alias messageContent: messageContent.text
    property alias backgroundColor: background.color
    property int contentWidth: 9999

    Component.onCompleted: () => {contentWidth = Math.max(messageSenderName.contentWidth, messageContent.contentWidth)}
    Rectangle{
        id: background
        color: "#ffffff"
        radius: 25
        anchors.fill: parent
    }
    Text{
        id: messageSenderName
        text: ""
        anchors.left: parent.left
        anchors.top: root.top
        font.pointSize: 10
        anchors.topMargin: 5
        anchors.leftMargin: 20
        anchors.rightMargin: 20
    }
    Text{
        id: messageContent
        text: ""
        elide: Text.ElideNone
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: root.bottom
        wrapMode: Text.WordWrap
        anchors.rightMargin: 20
        anchors.bottomMargin: 5
        anchors.leftMargin: 20
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.75}D{i:1}D{i:2}D{i:3}
}
##^##*/
