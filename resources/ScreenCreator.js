.pragma library

.import QtQuick 2.15 as QtQuick

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
        if(this.incubator.status !== QtQuick.Component.Ready)
        {
            this.incubator.onStatusChanged = status => {
                if(status === QtQuick.Component.Ready)
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
