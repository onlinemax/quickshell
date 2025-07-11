pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    property alias notificationServer: notifServer

    NotificationServer {
        id: notifServer
        actionsSupported: true
        persistenceSupported: true
    }

    Connections {
        target: notifServer

        function onNotification(notification) {
            notification.tracked = true;
        }
    }
}
