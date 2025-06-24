import QtQuick

Rectangle {
    id: wrapper
    readonly property int padding: 5
    property bool shown: false
    implicitWidth: dashboard.height + 2 * wrapper.padding
    implicitHeight: dashboard.height + 2 * padding
    y: -wrapper.height
    color: 'red'
    Item {
        id: dashboard
        implicitWidth: 500
        implicitHeight: 300
    }
    states: [
        State {
            name: ""
            when: !wrapper.shown
            PropertyChanges {
                wrapper {
                    y: -wrapper.height
                }
            }
        },
        State {
            name: "visible"
            when: wrapper.shown
            PropertyChanges {
                wrapper {
                    y: 40
                }
            }
        }
    ]
    transitions: Transition {
        NumberAnimation {
            target: wrapper
            property: "y"
            duration: 400
            easing.type: Easing.InOutQuad
        }
    }
}
