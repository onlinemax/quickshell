import QtQuick

Rectangle {
    property var onClicked
    property var onEntered
    property var onExited

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (parent.onClicked != null)
                parent.onClicked();
        }
        onEntered: {
            if (parent.onEntered != null)
                parent.onEntered();
        }
        onExited: {
            if (parent.onExited != null)
                parent.onExited();
        }
    }
}
