.import "ScreenCreator.js" as SC

function Timer() {
    return Qt.createQmlObject("import QtQuick 2.0; Timer {}", mains);
}

function log(message) //вывод логов в экран разработчика
{
    serverScreen.logTextAreaText += message
}

function backToWelcomeScreenButtonClicked()
{
    var item = mainStack.currentItem;
    mainStack.pop();
    var timer = new Timer();
    timer.interval = 500;
    timer.repeat = false;
    timer.triggered.connect(() => {item.destroy(); timer.destroy()});
    timer.start();
}

function welcomeScreen_onLoginButtonClicked(){
    var screenCreator = new SC.ScreenCreator("FormScreen.qml");
    screenCreator.parameters = {
        namesArray: [qsTr("Почта"), qsTr("Пароль")],
        textFieldsArray: [qsTr("Введите почту"), qsTr("Введите пароль")],
        finalButtonText: qsTr("Войти"),
        labelText: "Вход",
        id: "loginScreen"
    };
    function getMessage(messageStr, errorCode, additionalDataArray){
        switch(messageStr){
            case "loginComplete":
               console.log("мы получили в экране логина сообщение о логине!");
               break;
        }
    }
    screenCreator.create(mains, object => {
        mainStack.push(object);
        object.onBackButtonClicked. connect(backToWelcomeScreenButtonClicked);
        object.onFinalButtonClicked.connect( () => {
            var array = mainStack.currentItem.getFieldsValues();
            BesClient.makeRequest("login", array);
        });
        object.getMessage = getMessage;
    });
}

function welcomeScreen_onRegButtonClicked(){
    var screenCreator = new SC.ScreenCreator("FormScreen.qml");
    screenCreator.parameters = {
        namesArray: [qsTr("Имя"), qsTr("Фамилия"), qsTr("Почта"), qsTr("Пароль")],
        textFieldsArray: [qsTr("Введите имя"), qsTr("Введите фамилию"), qsTr("Введите почту"), qsTr("Введите пароль")],
        finalButtonText: qsTr("Зарегистрироваться"),
        labelText: qsTr("Регистрация"),
        id: "regScreen"
    };
    function getMessage(messageStr, errorCode, additionalDataArray){
        switch(messageStr){
            case "registrationComplete":
                registrationComplete(errorCode, additionalDataArray);
                break;
        }
    }

    screenCreator.create(mains, object => {
        mainStack.push(object);
        object.onBackButtonClicked. connect(backToWelcomeScreenButtonClicked);
        object.onFinalButtonClicked.connect(() => {
            var array = mainStack.currentItem.getFieldsValues();
            BesClient.makeRequest("registration", array);
        });
    });
}

function loginComplete (errorCode, dataArray)
{
    if(errorCode === 0)
    {

    }
    else
    {
        notifications.notify(dataArray[0], "Ошибка авторизации (" + errorCode + ")");
    }
}

function registrationComplete (errorCode, dataArray)
{
    if(errorCode === 0)
    {
        //TODO: сюда первым делом вкинуть маску на ввод только чисел
        var screenCreator = new SC.ScreenCreator("FormScreen.qml");
        screenCreator.parameters = {
            namesArray: [qsTr("Код")],
            textFieldsArray: [qsTr("Введите код")],
            finalButtonText: qsTr("Отправить"),
            labelText: qsTr("Подтверждение почты"),
            id: "regCodeScreen"
        };
        function getMessage(messageStr, errorCode, additionalDataArray){
            switch(messageStr){
                case "regCodeCompleted":
                    console.log("regCodeСompleted");
                    break;
            }
        }

        screenCreator.create(mains, object => {
            mainStack.push(object);
            object.onBackButtonClicked. connect(backToWelcomeScreenButtonClicked);
            object.onFinalButtonClicked.connect(() => {
                var array = mainStack.currentItem.getFieldsValues();
                BesClient.makeRequest("regCode", array);
            });
        });
    }
    else
    {
        notifications.notify(dataArray[0], "Ошибка регистрации (" + errorCode + ")");
    }
}
