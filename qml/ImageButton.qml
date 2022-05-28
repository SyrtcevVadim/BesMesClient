import QtQuick
import QtQuick.Controls

Image {
    id: root
    required property string source_deactivated;
    required property string source_activated;

    signal clicked;

    source: area.containsPress? source_activated : source_deactivated

    MouseArea {
        id: area
        anchors.fill: parent
        onClicked: root.clicked()
        onContainsPressChanged: {
            let prevWidth = root.width
            let prevHeight = root.height
            root.source = area.containsPress? source_activated : source_deactivated
            root.sourceSize.width = prevWidth
            root.sourceSize.height = prevHeight
        }
    }
}
