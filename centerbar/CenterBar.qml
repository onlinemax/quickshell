import QtQuick
import QtQuick.Controls

import ".."

Button {
    required property string time
    required property var toggleMenu

    Text {
        text: time
        color: Colors.on_background
        anchors.centerIn: parent
    }
    background: Rectangle {
        id: rectangle
        color: Colors.background
        scale: 1
        topLeftRadius: parent.implicitHeight / 2
        topRightRadius: parent.implicitHeight / 2
        bottomLeftRadius: parent.implicitHeight / 2
        bottomRightRadius: parent.implicitHeight / 2

        Behavior on scale {
            PropertyAnimation {
                duration: 200
                easing.type: Easing.InSine
            }
        }
    }
    onClicked: {
        rectangle.scale = 1.2;
        this.toggleMenu();
        timer.running = true;
    }
    Timer {
        id: timer
        interval: 200
        onTriggered: {
            rectangle.scale = 1.0;
        }
    }
}
