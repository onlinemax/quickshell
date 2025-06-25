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
        height: parent.height
        color: Colors.primary
        radius: 10
    }
    contentItem: Rectangle {
        height: control.height * control.visualPosition
        anchors.top: parent.top
        color: Colors.on_primary
        topRightRadius: 10
        topLeftRadius: 10
    }
    Component.onCompleted: {}
}
