import QtQuick.Controls
import QtQuick
import ".."

ProgressBar {
    id: control
    required property real val
    from: 0
    value: control.val
    to: 100
    background: Rectangle {
        width: parent.width
        color: Colors.on_secondary
        height: parent.height
        radius: 10
    }
    contentItem: Rectangle {
        height: control.height * control.visualPosition
        anchors.bottom: parent.bottom
        color: Colors.secondary
        radius: 10
        Behavior on height {
            NumberAnimation {
                duration: 200
            }
        }
    }
}
