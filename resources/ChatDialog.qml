import QtQuick

Item {
    id: root
    property alias backgroundColor: background.color
    Rectangle{
        id: background
        anchors.fill: root
        color: "#FFFFFF"
    }
    Rectangle{
        id: header
        z:1
        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        color: "#B0FFDE"
        height: 60
    }

    ListView{
        id: messageList
        anchors.top: header.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: footer.top
        model: chatModel
        spacing: 10
        verticalLayoutDirection: ListView.BottomToTop
        delegate: Row{
            layoutDirection: isSender ? Qt.RightToLeft : Qt.LeftToRight
            width: messageList.width
            ChatDialogMessage{
                backgroundColor: color
                messageContent: message
                messageSenderName: name
                width: getWidth()
                function getWidth(){
                    var realWidth = contentWidth + 50
                    if(realWidth > root.width*0.85){
                        return root.width * 0.85
                    }
                    else{
                        return realWidth
                    }
                }
            }
        }
    }
    Rectangle{
        id: footer
        z:1
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        color: "#B0FFDE"
        height: 50
    }

    ListModel{
        id: chatModel
        ListElement{
            color: "#73FFC5"
            name: "Владимир Воропаев"
            message: "Успеешь по срокам?"
            isSender: true
        }
        ListElement{
            color: "#EDFCF5"
            name: "Екатерина Жужликова"
            message: "Постараюсь, но ничего не обещаю"
            isSender: false
        }
    }
}
