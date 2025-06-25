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
    onVisibleChanged: console.log('timemenu visibled?', visible)

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

    transitions: [
        Transition {
            from: ""
            to: "visible"
            SequentialAnimation {
                PropertyAction {
                    target: root
                    property: "visible"
                    value: true
                }
                NumberAnimation {
                    property: "y"
                    duration: 500
                    easing.type: Easing.BezierSpline
                }
            }
        },
        Transition {
            from: "visible"
            to: ""
            SequentialAnimation {
                NumberAnimation {
                    property: "y"
                    duration: 500
                    easing.type: Easing.BezierSpline
                }
                PropertyAction {
                    target: root
                    property: "visible"
                    value: false
                }
            }
        }
    ]

    Calendar {}
}
