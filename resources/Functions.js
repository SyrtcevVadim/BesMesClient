function loginButtonClicked()
{
    console.log("loginButtonClicked");
    mainStack.push(loginScreen);
}

function serverButtonClicked()
{
    console.log("serverButtonClicked");
    mainStack.push(serverScreen);
}

function changeServerStatus(isConnected)
{
    console.log("статус сервера - " + isConnected ? "Подключен" : "Отключен");
    serverScreen.serverStatus = isConnected ? "Подключен" : "Отключен";
}

function connectToServer()
{
    console.log("подключаемся");
    BesClient.connectToServer();
}

function disconnectFromServer()
{
    console.log("отключаемся");
    BesClient.disconnectFromServer();
}

function login()
{
    console.log("логинимся");
    BesClient.login(loginScreen.loginText, loginScreen.passwordText)
}

function log(message)
{
    serverScreen.logTextAreaText += message
}
