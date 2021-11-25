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
    property int itemHeight: 40

    Component.onCompleted: {
        setlistModels()
    }
    function setlistModels(){
        for(var i = 0; i < namesArray.length; i++)
        {
            namesModel.append     ({"name": namesArray[i]});
            textFieldsModel.append({"text": textFieldsArray[i]})
        }
    }

    Text{
        text: "Вход"
        anchors.left: grid.left
        anchors.bottom: grid.top
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
        id: grid
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
            spacing: 25
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
        width: grid.width * 0.66
        text: "Войти"
        anchors.top: grid.bottom
        font.pixelSize: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 25
        onClicked: function (mouse){loginButtonClicked()}
    }

    Button {
        id: button
        width: 40
        text: qsTr("<-")
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.topMargin: 0
        onClicked: function(mouse){loginScreen.backButtonClicked()}
    }
}
