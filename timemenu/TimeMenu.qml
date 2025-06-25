import QtQuick
import ".."

Rectangle {
    id: root
    property bool shown: false
    x: (parent.width - root.width) / 2
    y: -height
    implicitWidth: 180
    implicitHeight: 190
    radius: 30
    color: Colors.background
    clip: true

    function toggleMenu() {
        this.shown = !this.shown;
    }

    states: [
        State {
            name: "visible"
            when: root.shown

            PropertyChanges {
                root {
                    y: 40
                }
            }
        },
        State {
            name: ""
            when: !root.shown
            PropertyChanges {
                root {
                    y: -height
                }
            }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            property: "y"
            duration: 500
            easing.type: Easing.BezierSpline
        }
    }

    Calendar {}
}
