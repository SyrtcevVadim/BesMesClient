.pragma library

function Timer() {
    return Qt.createQmlObject("import QtQuick 2.0; Timer {}", mains);
}
