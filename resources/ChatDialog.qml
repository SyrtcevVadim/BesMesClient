import QtQuick 2.15

Item {
    id: root
    property alias backgroundColor: background.color
    Rectangle{
        id: background
        anchors.fill: root
        color: "#FFFFFF"
    }
    ListView{
        anchors.fill: root
        model: chatModel
        spacing: 10
        delegate: ChatDialogMessage{
            backgroundColor: color
            messageContent: message
            messageSenderName: name
        }
    }
    ListModel{
        id: chatModel
        ListElement{
            color: "#73FFC5"
            name: "Владимир Воропаев"
            message: "Успеешь по срокам?"

        }
        ListElement{
            color: "#EDFCF5"
            name: "Екатерина Жужликова"
            message: "Постараюсь, но ничего не обещаю"
        }
    }
}
