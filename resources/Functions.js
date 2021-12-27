//необходимые рукописные компоненты
class ScreenCreator //"строитель" динамических элементов qml
{
    constructor(componentName)
    {
        this.object = Qt.createComponent(componentName);
        this.parameters = {};
    }

    create(parent, callback = null)
    {
        this.incubator = this.object.incubateObject(parent, this.parameters);
        if(this.incubator.status !== Component.Ready)
        {
            this.incubator.onStatusChanged = status => {
                if(status === Component.Ready)
                {
                    if(callback !== null)
                        callback(this.object);
                }
            }
        }
        else
        {
            if(callback !== null)
                callback(this.object);
        }
    }

    getObject()
    {
        return this.object;
    }

}

function setPropertiesOfCreatedScreen(item, method) //внешний метод для класса
{
    mainStack.push(item);
    item.onBackButtonClicked.connect(backToWelcomeScreenButtonClicked);
    item.onFinalButtonClicked.connect(method);
}
function backToWelcomeScreenButtonClicked() //это хоть и обработчик, но он общий для всех созданных экранов
{
    var item = mainStack.currentItem;
    mainStack.pop();
    var timer = new Timer();
    timer.interval = 500;
    timer.repeat = false;
    timer.triggered.connect(() => {item.destroy(); timer.destroy()});
    timer.start();
}
function Timer() { //конструктор объекта таймера
    return Qt.createQmlObject("import QtQuick 2.0; Timer {}", mains);
}

//функции обработчики событий QML
function loginButtonClicked()
{
    var screenCreator = new ScreenCreator("FormScreen.qml");
    screenCreator.parameters = {
        namesArray: ["Почта",
                     "Пароль"],
        textFieldsArray: ["Введите почту",
                          "Введите пароль"],
        finalButtonText: "Войти",
        labelText: "Вход",
        id: "loginScreen"
    };
    screenCreator.create(mains, object => {
        mainStack.push(object);
        object.onBackButtonClicked. connect(backToWelcomeScreenButtonClicked);
        object.onFinalButtonClicked.connect(proceedLoginProcedure);
    });
}

function registrationButtonClicked()
{
    var screenCreator = new ScreenCreator("FormScreen.qml");
    screenCreator.parameters = {
        namesArray: ["Имя", "Фамилия", "Почта", "Пароль"],
        textFieldsArray: ["Введите имя", "Введите фамилию", "Введите почту", "Введите пароль"],
        finalButtonText: "Зарегистрироваться",
        labelText: "Регистрация",
        id: "regScreen"
    };
    screenCreator.create(mains, object => {
        mainStack.push(object);
        object.onBackButtonClicked. connect(backToWelcomeScreenButtonClicked);
        object.onFinalButtonClicked.connect(proceedRegistrationProcedure);
    });
}

//функции старта процедур BesClient'а
function proceedLoginProcedure()
{
    var array = mainStack.currentItem.getFieldsValues();
    BesClient.login(array[0], array[1]);
}

function proceedRegistrationProcedure()
{
    var array = mainStack.currentItem.getFieldsValues();
    BesClient.registration(array[0], array[1], array[2], array[3]);
}

function proceedRegistrationCodeProcedure()
{
    var array = mainStack.currentItem.getFieldsValues();
    BesClient.registrationCode(array[0]);
}

//обработка с++ событий
function changeServerStatus(isConnected)
{
    console.log("статус сервера - " + isConnected ? "Подключен" : "Отключен");
    serverScreen.serverStatus = isConnected ? "Подключен" : "Отключен";
}

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

function auntificationCompleted(isSuccess, answerCode, description)
{

}

function registrationComplete (isSuccess, answerCode, description)
{
    if(isSuccess)
    {
        //TODO: сюда первым делом вкинуть маску на ввод только чисел
        var screenCreator = new ScreenCreator("FormScreen.qml");
        screenCreator.parameters = {
            namesArray: ["Код"],
            textFieldsArray: ["Введите код"],
            finalButtonText: "Отправить",
            labelText: "Подтверждение почты",
            id: "regCodeScreen"
        };
        screenCreator.create(mains, object => {
            mainStack.push(object);
            object.onBackButtonClicked. connect(backToWelcomeScreenButtonClicked);
            object.onFinalButtonClicked.connect(proceedRegistrationCodeProcedure);
        });
    }
    else
    {

    }
}
