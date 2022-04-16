import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "jsconsole.js" as Util

ColumnLayout {
    id: root
    function jsCall(exp) {
        input.text = ''
        const data = Util.call(exp)
        // insert the result at the beginning of the list
        outputModel.insert(0, data)
    }
    function log(log)
    {
        const exp = 'this.log("' + log + '")';
        const data = Util.call(exp);
        data.expression = "Log message"
        outputModel.insert(0, data)
    }

    anchors.margins: 9
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Rectangle {
            anchors.fill: parent
            color: '#333'
            border.color: Qt.darker(color)
            opacity: 0.2
            radius: 2
        }

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors{
                topMargin: 15
                bottomMargin: 9
                leftMargin: 9
                rightMargin: 9
            }

            ListView {
                id: resultView
                verticalLayoutDirection: ListView.BottomToTop
                model: ListModel {
                    id: outputModel
                }
                delegate: ColumnLayout {
                    id: delegate
                    required property var model
                    width: ListView.view.width
                    Label {
                        Layout.fillWidth: true
                        color: 'green'
                        text: "> " + delegate.model.expression
                    }
                    Label {
                        Layout.fillWidth: true
                        color: delegate.model.error === "" ? 'blue' : 'red'
                        text: delegate.model.error === "" ? "" + delegate.model.result : delegate.model.error
                    }
                    Rectangle {
                        height: 1
                        Layout.fillWidth: true
                        color: '#333'
                        opacity: 0.2
                    }
                }
            }
        }
    }
    RowLayout {
        Layout.fillWidth: true
        TextField {
            id: input
            Layout.fillWidth: true
            focus: true
            onAccepted: {
                // call our evaluation function on root
                root.jsCall(input.text)
            }
        }
        Button {
            text: qsTr("Send")
            onClicked: {
                // call our evaluation function on root
                root.jsCall(input.text)
            }
        }
    }
}
