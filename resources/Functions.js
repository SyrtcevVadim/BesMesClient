//необходимые рукописные компоненты
class ScreenCreator{ //почти независимый класс (класс в js дада) для создания окон
    //TODO: добавление возможности накинуть маски на поля
    constructor(id, namesArray, textFieldsArray, finalButtonText, labelText, parentId, method)
    {
        this.namesArray      = namesArray;
        this.textFieldsArray = textFieldsArray;
        this.finalButtonText = finalButtonText;
        this.textFieldsArray = textFieldsArray;
        this.labelText       = labelText;
        this.parentId        = parentId;
        this.id              = id;
        this.method          = method;
    }
    createObject()
    {
        this.component = Qt.createComponent("FormScreen.qml");
            if (this.component.status === Component.Ready)
                this.finishCreation();
            else
                this.component.statusChanged.connect(this.finishCreation);
    }
    finishCreation()
    {
        if (this.component.status === Component.Ready)
        {
            var sprite = this.component.createObject(this.parentId, {namesArray: this.namesArray,
                                                                    textFieldsArray: this.textFieldsArray,
                                                                    finalButtonText: this.finalButtonText,
                                                                    labelText: this.labelText,
                                                                    id: this.id});
            if (sprite === null)
            {
                // Error Handling
                console.log("Error creating object");
            }
            setPropertiesOfCreatedScreen(sprite, this.method);
        }
        else if (this.component.status === Component.Error)
        {
            // Error Handling
            console.log("Error loading component:", this.component.errorString());
        }
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
    timer.triggered.connect(function(){item.destroy(); timer.destroy()});
    timer.start();
}
function Timer() { //конструктор объекта таймера
    return Qt.createQmlObject("import QtQuick 2.0; Timer {}", mains);
}

//функции обработчики событий QML
function loginButtonClicked()
{
    var screenCreator = new ScreenCreator("loginScreen", ["Почта", "Пароль"],
                                          ["Введите почту", "Введите пароль"],
                                          "Войти", "Вход",
                                          "mains", proceedLoginProcedure);
    screenCreator.createObject();
}

function registrationButtonClicked()
{
    var screenCreator = new ScreenCreator("regScreen", ["Имя", "Фамилия", "Почта", "Пароль"],
                                          ["Введите имя", "Введите фамилию", "Введите почту", "Введите пароль"],
                                          "Зарегистрироваться", "Регистрация",
                                          "mains", proceedRegistrationProcedure);
    screenCreator.createObject();
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

//обработка с++ событий
function changeServerStatus(isConnected)
{
    console.log("статус сервера - " + isConnected ? "Подключен" : "Отключен");
    serverScreen.serverStatus = isConnected ? "Подключен" : "Отключен";
}

function log(message) //вывод логов в экран разработчика
{
    serverScreen.logTextAreaText += message
}
