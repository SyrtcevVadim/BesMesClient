import QtQml 2.15
import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    id: base
    property var window

    property var notifications: []
    property var queue: []

    property int ySpacing: 50

    function timerObj() {
        return Qt.createQmlObject("import QtQuick 2.0; Timer {}", appWindow);
    }

    function notify(message, header){
        // Add message to queue
        base.queue.unshift({msg: message, head: header});
        tryNotify();
    }

    function tryNotify(){
        // if current y is greater than window.height
        if (notifications.length * ySpacing >= window.height - 10){
            var timer = Qt.createQmlObject("import QtQuick 2.0; Timer {}", base);
            timer.interval = 1000; // ms
            timer.repeat = false;
            timer.triggered.connect(function () {
                tryNotify();
            });

            timer.start();
        }
        else {
            // Get message from queue
            var message = base.queue.pop();
            var notifi = Qt.createQmlObject("Notification {}", window);
            notifi.headerText = message.head;
            notifi.bodyText = message.msg;
            notifi.y = notifications.length * ySpacing;

            notifications.push(notifi);
            notifi.open();

            notifi.closed.connect(function() {
                var index = notifications.indexOf(notifi);
                if (index > -1){
                    notifications.splice(index, 1);
                }

                notifi.destroy();

                // re position all notifications
                for (var i = 0;i<notifications.length;i++){
                    notifications[i].y = i * ySpacing;
                }
            });
        }
    }
}
