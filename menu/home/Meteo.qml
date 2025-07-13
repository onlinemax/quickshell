import QtQuick
import qs

Rectangle {
    radius: 15
    color: 'transparent'
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.color = Colors.primary
        onExited: parent.color = 'transparent'
    }
}
