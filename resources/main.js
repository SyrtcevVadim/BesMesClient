.import "ScreenCreator.js" as SC

function log(message) //вывод логов в экран разработчика
{
    serverScreen.logTextAreaText += message
//    var screenCreator = new ScreenCreator("Notification.qml");
//    screenCreator.parameters = {
//        headerText: "Header",
//        backgroundColor: "#808080",
//        textColor: "#ffffff",
//        bodyText: "Body"
//    };
//    screenCreator.create(serverScreen, null);
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
        namesArray: ["Почта", "Пароль"],
        textFieldsArray: ["Введите почту", "Введите пароль"],
        finalButtonText: "Войти",
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
        namesArray: ["Имя", "Фамилия", "Почта", "Пароль"],
        textFieldsArray: ["Введите имя", "Введите фамилию", "Введите почту", "Введите пароль"],
        finalButtonText: "Зарегистрироваться",
        labelText: "Регистрация",
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

function registrationComplete (errorCode, dataArray)
{
    if(errorCode === 0)
    {
        //TODO: сюда первым делом вкинуть маску на ввод только чисел
        var screenCreator = new SC.ScreenCreator("FormScreen.qml");
        screenCreator.parameters = {
            namesArray: ["Код"],
            textFieldsArray: ["Введите код"],
            finalButtonText: "Отправить",
            labelText: "Подтверждение почты",
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
        //надо писать уведомления, без них уже сложно
    }
}
