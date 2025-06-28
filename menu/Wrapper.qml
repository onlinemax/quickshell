import QtQuick
import ".."

Rectangle {
    id: wrapper
    required property var properties

    implicitWidth: 600
    implicitHeight: 400
    color: Colors.background
    anchors.horizontalCenter: parent.horizontalCenter
    state: properties.menuOpen ? "visible" : "hidden"
    visible: false

    MouseArea {
        Menu {
            id: menu
            focus: true
        }
        anchors.fill: parent
    }

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: wrapper
                implicitHeight: 400
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
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
}
