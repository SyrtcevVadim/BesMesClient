import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick 2.12
import QtQml 2.15

Item {
    id: pop
    width: 150
    height: 60
    property alias headerText: header.text
    property alias bodyText: body.text
    property alias backgroundColor: background.color
    property alias textColor: header.color
    property int iterator
    visible: false
    Component.onCompleted: {
        startTimer.start();
        visible = true;
        opacity = 0;
        iterator = 0;
    }
    Timer{
        id: startTimer;
        interval: 50
        running: false
        repeat: true
        onTriggered: function(){
            if(iterator < 20)
            {
                console.log(1)
                opacity = iterator / 30
            }
            else if(iterator > 60 && iterator != 80)
            {
                console.log(2)
                opacity = (80 - iterator)/ 30;
            }
            else if(iterator == 80)
            {
                console.log(3)
                pop.destroy();
            }
            console.log(iterator);
            iterator += 1;
        }
    }
    Rectangle {
        id: background
        color: "#808080"
        anchors.fill: parent
        radius: parent.width / 10
    }

    Text {
        id: header
        text: "111"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        font.pixelSize: 17
        horizontalAlignment: Text.AlignHCenter
    }
    Text {
        id: body
        text: "111"
        color: header.color
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        font.pixelSize: 17
        horizontalAlignment: Text.AlignHCenter
        anchors.topMargin: 2
        anchors.bottomMargin: 0
    }
}
