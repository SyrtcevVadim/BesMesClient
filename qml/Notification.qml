import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: popup
    focus: false
    width: 250
    height: header.contentHeight + body.contentHeight
    property alias headerText: header.text
    property alias bodyText: body.text
    property alias textColor: header.color

    closePolicy: Popup.NoAutoClose

    Timer {
        id: timer
        interval: 5000
        running: true
        repeat: false
        onTriggered: {
            popup.close()
        }
    }
    contentItem: MouseArea {
        onClicked: {
            popup.close()
        }
    }

    Text {
        id: header
        text: "111"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        font.pixelSize: 17
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }
    Text {
        id: body
        text: "121212121 121212121 121212 121212121111111 111 111 11 11  11 1111 111111 1111111111111"
        color: header.color
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        font.pixelSize: 17
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }
    onOpened: {
        timer.start()
    }
}


