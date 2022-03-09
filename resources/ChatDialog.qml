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
        verticalLayoutDirection: ListView.BottomToTop
        delegate: ChatDialogMessage{
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
