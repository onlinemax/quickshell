import QtQuick
import ".."
import "../utils/"

Rectangle {
    id: wrapper
    required property var properties

    implicitWidth: Appearance.width.xl
    implicitHeight: Appearance.height.large
    color: Colors.background
    anchors.horizontalCenter: parent.horizontalCenter
    visible: implicitHeight != 0
    state: properties.menuOpen ? "visible" : "hidden"

    MouseArea {

        hoverEnabled: true
        propagateComposedEvents: true
        acceptedButtons: Qt.AllButtons
        anchors.fill: parent
        z: 1

        onExited: {
            wrapper.properties.menuOpen = false;
        }
        Menu {
            id: menu
            focus: true
            properties: wrapper.properties
        }
    }

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: wrapper
                implicitHeight: Appearance.height.xl
            }
        },
        State {
            name: "hidden"
            PropertyChanges {
                target: wrapper
                implicitHeight: 0
            }
        }
    ]
    transitions: Transition {
        NumberAnimation {
            target: wrapper
            property: "implicitHeight"
            duration: Appearance.duration.little
            easing.type: Easing.InOutQuad
        }
    }
}
