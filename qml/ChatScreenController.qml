import QtQuick
import "ScreenCreator.js" as SC

QtObject {
    function deleteFormScreen()
    {
        var item = mainStack.currentItem;
        mainStack.pop();
        var timer = Qt.createQmlObject("import QtQuick 2.0; Timer {}", appRoot);
        timer.interval = 500;
        timer.repeat = false;
        timer.triggered.connect(() => {item.destroy(); timer.destroy()});
        timer.start();
    }

    function openAddNewChatScreen()
    {
        let ScreenCreator = new SC.ScreenCreator();
        ScreenCreator.parameters = {
            namesArray: [qsTr("Имя"), qsTr("Фамилия"), qsTr("Почта"), qsTr("Пароль")],
            textFieldsArray: [qsTr("Введите имя"), qsTr("Введите фамилию"), qsTr("Введите почту"), qsTr("Введите пароль")],
            finalButtonText: qsTr("Зарегистрироваться"),
            labelText: qsTr("Регистрация")
        };
        function submitFunction()
        {

        }
        function callbackFunction(object){
            mainStack.push(object);
            object.onClosed.connect(deleteFormScreen);
            object.onSubmit.connect(submitFunction)
        }
        ScreenCreator.create(root, callbackFunction)
    }
}
