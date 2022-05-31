import QtQuick
import QtQuick.Controls
import QtQuick.LocalStorage
import "ScreenCreator.js" as SC

QtObject {
    required property var mainStack
    required property var model
    function deleteFormScreen()
    {
        var item = mainStack.currentItem;
        mainStack.pop();
        var timer = Qt.createQmlObject("import QtQuick 2.0; Timer {}", root);
        timer.interval = 500;
        timer.repeat = false;
        timer.triggered.connect(() => {item.destroy(); timer.destroy()});
        timer.start();
    }

    function openAddNewChatScreen()
    {
        let ScreenCreator = new SC.ScreenCreator();
        ScreenCreator.parameters = {
            namesArray: [qsTr("Название чата")],
            textFieldsArray: [qsTr("Введите название чата")],
            finalButtonText: qsTr("Создать"),
            labelText: qsTr("Новый чат")
        };
        var chatName;
        function chatCreationRequestCompleted(json)
        {
            let object = JSON.parse(json)
            let chatId = object['ид_чата']

            database.addNewChat(chatName, chatId)
            model.sendChatCreationRequestCompleted.disconnect(chatCreationRequestCompleted)
        }

        function submitFunction()
        {
            let array = mainStack.currentItem.getFieldsValues()
            chatName = array[0]
            if(chatName === "")
                return
            model.sendChatCreationRequest(chatName)
            model.sendChatCreationRequestCompleted.connect(chatCreationRequestCompleted)
        }
        function callbackFunction(object){
            mainStack.push(object);
            object.onClosed.connect(deleteFormScreen);
            object.onSubmit.connect(submitFunction)
        }
        ScreenCreator.create(root, callbackFunction)
    }
    function sendMessage(text)
    {
        let chat_index = listView.currentIndex
        let chat_id = chatListModel.get(chat_index).id

        function callback(json){
            let object = JSON.parse(json)
            console.write(json)
        }

        model.sendMessageRequest(chat_id, text)
        model.sendMessageRequestCompleted(callback)
    }

    function synchronization()
    {
        console.log("ddd")
        database.getSynchronizationData(model)
        function callback(data){
            console.log(data)

            var dataObject = JSON.parse(data)
            var chatsArray = dataObject["чаты"]
            var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
            db.transaction(
                function(tx){
                    for(var i = 0; i < chatsArray.length; i++)
                    {
                        let chat_id = chatsArray[i]['ид_чата']
                        let messagesArray = chatsArray[i]['сообщения']
                        for(var msg = 0; msg < messagesArray.length; msg++)
                        {
                            let currentMessage = messagesArray[msg]
                            let query = "INSERT INTO message(body, chat_id, sender_id, time) VALUES (?, ?, ?, ?)"
                            tx.executeSql(query, [currentMessage['тело_сообщения'],
                                                  chat_id, currentMessage['ид_отправителя'],
                                                  currentMessage['время_отправления']]);
                        }
                    }
                }
            )



            database.synchronizationCompleted.disconnect(callback)
        }
        database.synchronizationCompleted.connect(callback)
    }
}
