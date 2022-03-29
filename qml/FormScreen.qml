import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQml
import QtQml.Models

Page {
    id: root
    property variant namesArray: ["One", "Two", "Three"]
    property variant textFieldsArray: ["oneText", "twoText", "threeText"]
    property alias finalButtonText: roundButton.text
    property alias labelText: label.text

    signal submit;
    signal closed;

    property int itemHeight: 40
    property int fontSize: itemHeight/3

    Component.onCompleted: {
        for(var i = 0; i < namesArray.length; i++)
        {
            namesModel.append     ({"name": namesArray[i]});
            textFieldsModel.append({"text": textFieldsArray[i]})
        }
    }

    function getFieldsValues()
    {
        var array = [];
        for(var i = 0; i < fieldsRepeater.count; i++)
        {
            array[i] = fieldsRepeater.itemAt(i).text;
        }
        return array;
    }

    background: Rectangle{
        anchors.fill: parent
        color: "white"
    }
    visible: false

    Text{
        id: label
        text: "Вход"
        anchors.left: row.left
        anchors.bottom: row.top
        font.pixelSize: 35
        anchors.leftMargin: -37
        anchors.bottomMargin: 24

    }
    ListModel{
        id: namesModel
    }
    ListModel{
        id: textFieldsModel
    }

    Row{
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: 25
        anchors.horizontalCenter: parent.horizontalCenter
        Column{
            spacing: 10
            Repeater{
                id: textRepeater
                model: namesModel
                delegate: Text {
                    text: name
                    font.pixelSize: height * 0.5
                    height: root.itemHeight
                }
            }
        }
        Column{
            spacing: 10
            Repeater{
                id: fieldsRepeater
                model: textFieldsModel

                delegate: TextField{
                    background: Rectangle
                    {
                        radius: root.itemHeight / 4
                        border.width: 0
                        color: "#edfcf5"
                    }
                    width : 200
                    font.pixelSize: root.fontSize
                    placeholderText: text
                    selectByMouse: true
                    height: root.itemHeight
                }
            }
        }
    }

    RoundButton {
        id: roundButton
        background: Rectangle
        {
            radius: root.itemHeight / 4
            color: "#73ffc5"
        }
        height: root.itemHeight
        width: row.width * 0.66
        text: "Войти"
        anchors.top: row.bottom
        font.pixelSize: root.fontSize
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 25
        onClicked: root.submit()
    }

    Button {
        id: backButton
        width: 40
        text: "<-"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.topMargin: 0
        onClicked: root.closed()
    }
}
