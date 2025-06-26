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
        color: Colors.on_primary
        height: parent.height
        radius: 10
    }
    contentItem: Rectangle {
        height: control.height * control.visualPosition
        anchors.top: parent.top
        color: Colors.primary
        topLeftRadius: 10
        topRightRadius: 10
        bottomRightRadius: 0
        bottomLeftRadius: 0
    }
}
