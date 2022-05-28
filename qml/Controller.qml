 import QtQuick
import "ScreenCreator.js" as SC

QtObject {
    function openServerScreen()
    {
        mainStack.push(serverScreen)
    }

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

    function createRegistrationScreen()
    {
        var ScreenCreator = new SC.ScreenCreator()
        //данные параметры будут переданны в созданный объект
        ScreenCreator.parameters = {
            namesArray: [qsTr("Имя"), qsTr("Фамилия"), qsTr("Почта"), qsTr("Пароль")],
            textFieldsArray: [qsTr("Введите имя"), qsTr("Введите фамилию"), qsTr("Введите почту"), qsTr("Введите пароль")],
            finalButtonText: qsTr("Зарегистрироваться"),
            labelText: qsTr("Регистрация")
        };

        function registrationCompleted (code)
        {
            if(code === 0) // удачное
            {
                //открыть окно
            }
            else
            {
                mainStack.showWindow(qsTr("Ошибка"), qsTr("При выполнении операции произошла ошибка, код ошибки: ") + code);
            }
            model.registrationRequestCompleted.disconnect(registrationCompleted);
        }

        function submitFunction(){
            //обращение к с++ модели - запрос на авторизацию
            var array = mainStack.currentItem.getFieldsValues()
            model.registrationRequestCompleted.connect(registrationCompleted);
            model.sendRegistrationRequest(array[0], array[1], array[2], array[3])
        }

        function callbackFunction(object){
            mainStack.push(object);
            object.onClosed.connect(deleteFormScreen);
            object.onSubmit.connect(submitFunction)
        }

        ScreenCreator.create(appRoot, callbackFunction);
    }

    function createLoginScreen()
    {
        var ScreenCreator = new SC.ScreenCreator()
        //данные параметры будут переданны в созданный объект
        ScreenCreator.parameters = {
            namesArray: [qsTr("Почта"), qsTr("Пароль")],
            textFieldsArray: [qsTr("Введите почту"), qsTr("Введите пароль")],
            finalButtonText: qsTr("Войти"),
            labelText: "Вход"
        }

        function loginCompleted(code)
        {
            if(code === 0) // удачное
            {
                //открыть окно
            }
            else
            {
                mainStack.showWindow(qsTr("Ошибка"), qsTr("При выполнении операции произошла ошибка, код ошибки: ") + code);
            }
            model.loginRequestCompleted.disconnect(loginCompleted);
        }
        function submitFunction(){
            //обращение к с++ модели - запрос на авторизацию
            var array = mainStack.currentItem.getFieldsValues()
            model.loginRequestCompleted.connect(loginCompleted);
            model.sendLoginRequest(array[0], array[1])
        }

        function callbackFunction(object){
            mainStack.push(object);
            object.onClosed.connect(deleteFormScreen);
            object.onSubmit.connect(submitFunction)
        }

        ScreenCreator.create(appRoot, callbackFunction);
    }

    function serverStatusChanged()
    {

    }

    function startApplication()
    {
        model.connectToServer()
    }
}
