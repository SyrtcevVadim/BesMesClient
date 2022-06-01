.pragma library

.import QtQuick 2.15 as QtQuick

//данный "класс" позволяет инкапсулировать весь процесс динамического создания QML элементов
class ScreenCreator
{
    constructor(componentName = "FormScreen.qml")
    {
        this.object = Qt.createComponent(componentName);
        //массив свойств, которые будут переданы создаваемому элементу
        this.parameters = {};
    }

    //callback - функция, вызываемая после окончания процесса создания
    create(parent, callback = null)
    {
        this.incubator = this.object.incubateObject(parent, this.parameters);
        if(this.incubator.status !== QtQuick.Component.Ready)
        {
            this.incubator.onStatusChanged = status => {
                if(status === QtQuick.Component.Ready)
                {
                    if(callback !== null)
                        callback(this.incubator.object);
                }
            }
        }
        else
        {
            if(callback !== null)
                callback(this.incubator.object);
        }
    }

    getObject()
    {
        return this.object;
    }

}
