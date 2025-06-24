// Time.qml
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property string time: {
        Qt.formatDateTime(clock.date, "d MMM hh:mm");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
