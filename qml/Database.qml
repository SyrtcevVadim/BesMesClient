import QtQuick
import QtQuick.LocalStorage
import QtQuick.Controls

QtObject {
    property string createMessageTable: `
    CREATE TABLE IF NOT EXISTS message (
        id         integer PRIMARY KEY AUTOINCREMENT,
        body       text,
        chat_id    integer,
        sender_id  integer,
        time       integer
    );
    `
    property string dropMessageTable:`
    DROP TABLE IF EXISTS message;
    `
    property string createChatTable : `
    CREATE TABLE IF NOT EXISTS chat (
        id         integer PRIMARY KEY,
        chat_name  text
    );
    `
    property string dropChatTable:`
    DROP TABLE IF EXISTS chat;
    `
    property string createUserTable: `
    CREATE TABLE IF NOT EXISTS user (
        id         integer PRIMARY KEY,
        first_name text,
        last_name  text,
        email      text
    );
    `
    property string dropUserTable:`
    DROP TABLE IF EXISTS user;
    `
    property string getChatsList: `
    SELECT id, chat_name FROM chat;
    `
    property string getChatMessages:`
    SELECT message.body as msg, user.name || ' ' || user.surname as full_name
    FROM message
    JOIN user ON message.sender_id = user.id
    WHEN chat_id =
    `
    property string test: `
    INSERT INTO message(body, chat_id, sender_id, time) VALUES
    ("test1", 1, 1, 1654004194),
    ("test2", 1, 2, 1654004194),
    ("test3", 1, 3, 1654004194),
    ("test4", 2, 1, 1654004194),
    ("test5", 2, 2, 1654004194),
    ("test6", 2, 3, 1654004194);
    `
    signal chatListUpdated;
    function createDatabase()
    {
        console.log("db created")
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                tx.executeSql(createMessageTable);
                tx.executeSql(createChatTable);
                tx.executeSql(createUserTable);
            }
        );
    }
    function dropDatabase()
    {
        console.log("db dropped")
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                tx.executeSql(dropMessageTable);
                tx.executeSql(dropChatTable);
                tx.executeSql(dropUserTable);
            }
        );
    }

    function updateChatListModel(modelElement)
    {
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                var result = tx.executeSql(getChatsList)
                modelElement.clear()
                for (var i = 0; i < result.rows.length; i++)
                {
                    modelElement.append
                    ({
                        id: result.rows.item(i).id,
                        name: result.rows.item(i).chat_name
                    });
                    for(let key in result.rows.item(i))
                    {
                        console.log(key + " " + result.rows.item(i)[key])
                    }
                }
            }
        );
    }

    function testRecords(modelElement)
    {
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                tx.executeSql(dropMessageTable)
                tx.executeSql(createMessageTable)
                var result = tx.executeSql(test)
                for(var key in result)
                {
                    console.log(key + " " + result[key])
                }
                for (let i = 0; i < result.rows.length; i++)
                {
                    for(let key in result.rows.item(i))
                    {
                        console.log(key + " " + result.rows.item(i)[key])
                    }
                }
            }
        );
    }

    function executeModelRequest(request)
    {
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                var result = tx.executeSql(request)
                for(var key in result)
                {
                    console.log(key + " " + result[key])
                }
            }
        );
    }

    function getUsers(model, callback = null)
    {

        function request_callback(jsonString)
        {
            var data = JSON.parse(jsonString)
            var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)

            db.transaction(
                function(tx) {
                    tx.executeSql(dropUserTable)
                    tx.executeSql(createUserTable)
                    let usersList = data["пользователи"]
                    if(usersList.length === 0)
                        return;
                    let query = "INSERT INTO user (id, first_name, last_name, email) VALUES"
                    for(let i = 0; i < usersList.length; i++)
                    {
                        let id = usersList[i]["ид_пользователя"]
                        let first_name = usersList[i]["имя"]
                        let last_name = usersList[i]["фамилия"]
                        let email = usersList[i]["почта"]
                        query += ` ("${id}", "${first_name}", "${last_name}", "${email}")`
                        if(i !== usersList.length-1 )
                            query += ','
                        else
                            query += ';'
                    }
                    console.log(query)
                    tx.executeSql(query)
                }
            );
            if(callback !== null)
                callback();
            model.sendUserListRequestCompleted.disconnect(request_callback)
        }
        model.sendUserListRequest()
        model.sendUserListRequestCompleted.connect(request_callback)
    }
    function getCurrentUserId(email)
    {
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        let returnItem;
        db.transaction(
            function(tx) {
                let query = `SELECT id FROM user WHERE email = "${email}"`
                let result = tx.executeSql(query)
                returnItem = result.rows.item(0).id;
            }
        );
        return returnItem;
    }

    function getChatList(model, callback = null)
    {
        function request_callback(jsonString)
        {
            var data = JSON.parse(jsonString)
            var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
            console.log("пришел ответ на чатлист")
            db.transaction(
                function(tx) {
                    tx.executeSql(dropChatTable)
                    tx.executeSql(createChatTable)
                    let chatList = data["чаты"]
                    if(chatList.length === 0)
                        return;
                    let query = "INSERT INTO chat (id, chat_name) VALUES"
                    for(let i = 0; i < chatList.length; i++)
                    {
                        let id = chatList[i]["ид_чата"]
                        let chat_name = chatList[i]["название"]
                        query += ` ("${id}", "${chat_name}")`
                        if(i !== chatList.length-1 )
                            query += ', '
                        else
                            query += ';'
                    }
                    console.log(query)
                    tx.executeSql(query)
                }
            );
            if(callback !== null)
                callback()
            model.sendChatListRequestCompleted.disconnect(request_callback)
        }

        model.sendChatListRequest()
        model.sendChatListRequestCompleted.connect(request_callback)
    }

    function addNewChat(chat_name, chat_id)
    {
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                let query = `INSERT INTO chat (id, chat_name) VALUES (${chat_id}, "${chat_name}");`
                console.log(query)
                tx.executeSql(query)
            }
        );
        chatListUpdated()
    }

    function updateDialogMessagesModel(messagesmodel, chat_id, model)
    {
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                let current_id = model.user_id
                let query = getChatMessages + `${chat_id};`;
                var result = tx.executeSql(query)
                messagesmodel.clear()
                for (var i = 0; i < result.rows.length; i++)
                {
                    messagesmodel.append
                    ({
                         name: result.rows.item(i).full_name,
                         message: result.rows.item(i).msg,
                         isSender: true
                    });
                    for(let key in result.rows.item(i))
                    {
                        console.log(key + " " + result.rows.item(i)[key])
                    }
                }
            }
        );
    }

    function getMessages()
    {

    }
}
