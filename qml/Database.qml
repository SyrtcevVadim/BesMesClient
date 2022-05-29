import QtQuick
import QtQuick.LocalStorage

QtObject {
    property string createMessageTable: `
    CREATE TABLE IF NOT EXISTS message (
    id         integer PRIMARY KEY AUTOINCREMENT,
        body       text,
        chat_id    integer,
        sender_id  integer
    );
    `
    property string createChatTable : `
    CREATE TABLE IF NOT EXISTS chat (
        id         integer PRIMARY KEY,
        chat_name  text
    );
    `
    property string createUserTable: `
    CREATE TABLE IF NOT EXISTS user (
        id         integer PRIMARY KEY AUTOINCREMENT,
        first_name text,
        last_name  text,
        email      text
    );
    `
    property string getChatsList: `
    SELECT id, chat_name FROM chat;
    `
    property string test: `
    INSERT INTO chat (id, chat_name)
    VALUES (1, "firstChat"),
           (2, "secondChat"),
           (3, "thirdChat");
    `
    Component.onCompleted: openDatabase()
    function openDatabase()
    {
        console.log("db opened")
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                tx.executeSql(createMessageTable);
                tx.executeSql(createChatTable);
                tx.executeSql(createUserTable);
            }
        );
    }

    function updateChatListModel(modelElement)
    {
        var db = LocalStorage.openDatabaseSync(":memory:", "1.0", "test", 1000000)
        db.transaction(
            function(tx) {
                var result = tx.executeSql(getChatsList)
                for(var key in result.rows)
                {
                    console.log(key + " " + result[key])
                }
                modelElement.clear()
                for (var i = 0; i < result.rows.length; i++)
                {
                    modelElement.append
                    ({
                        id: result.rows.item(i).id,
                        name: result.rows.item(i).chat_name
                    });
                    for(var keyy in result.rows.item(i))
                    {
                        console.log(keyy + " " + result.rows.item(i)[keyy])
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
                var result = tx.executeSql(test)
                for(var key in result)
                {
                    console.log(key + " " + result[key])
                }
            }
        );
    }
}
