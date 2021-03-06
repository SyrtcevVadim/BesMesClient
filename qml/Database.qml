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
    property string getMessageTable: `
    SELECT * FROM message;
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
    property string getChatTable: `
    SELECT * FROM chat;
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
    property string getUserTable: `
    SELECT * FROM user;
    `
    property string getChatsList: `
    SELECT id, chat_name FROM chat;
    `
    property string getChatMessages:`
    SELECT message.body as msg, user.first_name || ' ' || user.last_name as full_name, user.id
    FROM message
    JOIN user ON message.sender_id = user.id
    WHERE message.chat_id = `
    property string synchronizationQuery: `
    SELECT max(time) FROM message
    `
    property string test: `
    INSERT INTO message(body, chat_id, sender_id, time) VALUES
    ("test1", 4, 1, 1654004194),
    ("test2", 4, 2, 1654004194),
    ("test3", 4, 3, 1654004194),
    ("test4", 12, 1, 1654004194),
    ("test5", 12, 2, 1654004194),
    ("test6", 12, 3, 1654004194);
    `
    signal chatListUpdated;
    signal synchronizationCompleted(var data);
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

    function getTableChat()
    {
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                let result = tx.executeSql(getChatTable);
                for(let i = 0; i < result.rows.length; i++)
                {
                    for(let key in result.rows.item(i))
                        console.log(key + ': '+result.rows.item(i)[key])
                }
            }
        );
    }

    function getTableUser()
    {
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                let result = tx.executeSql(getUserTable);
                for(let i = 0; i < result.rows.length; i++)
                {
                    for(let key in result.rows.item(i))
                        console.log(key + ': '+result.rows.item(i)[key])
                }
            }
        );
    }

    function getTableMessages()
    {
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                let result = tx.executeSql(getMessageTable);
                for(let i = 0; i < result.rows.length; i++)
                {
                    for(let key in result.rows.item(i))
                        console.log(key + ': '+result.rows.item(i)[key])
                }
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
                    let usersList = data["????????????????????????"]
                    if(usersList.length === 0)
                        return;
                    let query = "INSERT INTO user (id, first_name, last_name, email) VALUES"
                    for(let i = 0; i < usersList.length; i++)
                    {
                        let id = usersList[i]["????_????????????????????????"]
                        let first_name = usersList[i]["??????"]
                        let last_name = usersList[i]["??????????????"]
                        let email = usersList[i]["??????????"]
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
            console.log("???????????? ?????????? ???? ??????????????")
            db.transaction(
                function(tx) {
                    tx.executeSql(dropChatTable)
                    tx.executeSql(createChatTable)
                    let chatList = data["????????"]
                    if(chatList.length === 0)
                        return;
                    let query = "INSERT INTO chat (id, chat_name) VALUES"
                    for(let i = 0; i < chatList.length; i++)
                    {
                        let id = chatList[i]["????_????????"]
                        let chat_name = chatList[i]["????????????????"]
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
        //console.log("update messages")
        db.transaction(
            function(tx) {
                let current_id = model.user_id
                //console.log(current_id)
                let query = getChatMessages + chat_id + ';';
                //console.log(query)

                let result = tx.executeSql(query)
                //console.log("length: " + result.rows.length)
                messagesmodel.clear()
                for (var i = result.rows.length-1; i >= 0; i--)
                {
                    //console.log("?????????? ??????????????????")
                    let isSender = result.rows.item(i)['id'] == current_id
                    //console.log('???????????????????????' + isSender)
                    messagesmodel.append
                    ({
                         name: result.rows.item(i).full_name,
                         message: result.rows.item(i).msg,
                         isSender: isSender
                    });
                    for(let key in result.rows.item(i))
                    {
                        //console.log(key + " " + result.rows.item(i)[key])
                    }
                }
            }
        );
    }

    function getSynchronizationData(model)
    {
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        var time;
        db.transaction(
            function(tx) {
                var result = tx.executeSql(synchronizationQuery)
                time = result.rows.item(0)['max(time)']
                if(time === null)
                    time = 0
            }
        );
        model.sendSynchronizationRequest(time)
        function onRequestCompleted(json)
        {
            synchronizationCompleted(json)
            model.sendSynchronizationRequestCompleted.disconnect(onRequestCompleted)
        }
        model.sendSynchronizationRequestCompleted.connect(onRequestCompleted)
    }
}
