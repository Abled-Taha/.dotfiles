import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Scope {
    id: root

    property var activeNotifications: []

    NotificationServer {
        id: serverRef

        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: notification => {
            var data = {
                id: notification.id || Math.random(),
                appName: notification.appName ? String(notification.appName) : "System",
                summary: notification.summary ? String(notification.summary) : "",
                body: notification.body ? String(notification.body) : "",
                ref: notification
            };

            var list = root.activeNotifications.slice();
            list.push(data);
            root.activeNotifications = list;

            var timeout = notification.expireTimeout > 0 ? notification.expireTimeout : 5000;
            var timer = Qt.createQmlObject('import QtQuick; Timer { interval: ' + timeout + '; running: true; repeat: false; }', root);
            timer.triggered.connect(() => {
                root.dismiss(data);
                timer.destroy();
            });
        }
    }

    function dismiss(item) {
        if (!item) return;

        var list = root.activeNotifications.filter(n => n.id !== item.id);
        root.activeNotifications = list;

        if (item.ref) {
            if (typeof item.ref.dismiss === "function") {
                item.ref.dismiss();
            } else if (typeof item.ref.close === "function") {
                item.ref.close();
            }
        }
    }
}
