import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQml 2.15
import QtQml.Models 2.15

Page {
    id: formScreen
    background: Rectangle{
        anchors.fill: parent
        color: "white"
    }
    property variant namesArray: ["One", "Two", "Three"]
    property variant textFieldsArray: ["oneText", "twoText", "threeText"]
    property alias finalButtonText: roundButton.text
    property alias labelText: label.text

    signal finalButtonClicked;
    signal backButtonClicked;
    property int itemHeight: 40

    Component.onCompleted: {
        function setlistModels(){
            for(var i = 0; i < namesArray.length; i++)
            {
                namesModel.append     ({"name": namesArray[i]});
                textFieldsModel.append({"text": textFieldsArray[i]})
            }
        }
        setlistModels();
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
                    height: formScreen.itemHeight
                }
            }
        }
        Column{
            spacing: 10
            Repeater{
                id: fieldsRepeater
                model: textFieldsModel
                delegate: TextField{
                    placeholderText: text
                    selectByMouse: true
                    height: formScreen.itemHeight
                }
            }
        }
    }

    RoundButton {
        id: roundButton
        width: row.width * 0.66
        text: "Войти"
        anchors.top: row.bottom
        font.pixelSize: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 25
        onClicked: function (mouse){formScreen.finalButtonClicked()}
    }

    Button {
        id: backButton
        width: 40
        text: "<-"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.topMargin: 0
        onClicked: function(mouse){formScreen.backButtonClicked()}
    }
}
