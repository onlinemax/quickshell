import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import ".."
import "../utils"

Rectangle {
    id: wrapper
    readonly property int padding: 5
    property bool shown: false
    radius: 25
    implicitWidth: 300 + 2 * wrapper.padding
    implicitHeight: 300 + 2 * padding
    y: -wrapper.height
    color: Colors.background
    states: [
        State {
            name: "notvisible"
            when: !wrapper.shown
            PropertyChanges {
                wrapper {
                    y: -wrapper.height
                    visible: false
                }
            }
        },
        State {
            name: "visible"
            when: wrapper.shown
            PropertyChanges {
                wrapper {
                    y: 40
                    visible: true
                }
            }
        }
    ]
    transitions: [
        Transition {
            from: "notvisible"
            to: "visible"
            SequentialAnimation {
                PropertyAction {
                    target: wrapper
                    property: "visible"
                    value: true
                }
                NumberAnimation {
                    target: wrapper
                    property: "y"
                    duration: 400
                    easing.type: Easing.InOutQuad
                }
            }
        },
        Transition {
            from: "visible"
            to: "notvisible"
            reversible: true
            SequentialAnimation {
                NumberAnimation {
                    target: wrapper
                    property: "y"
                    duration: 400
                    easing.type: Easing.InOutQuad
                }
                PropertyAction {
                    target: wrapper
                    property: "visible"
                    value: false
                }
            }
        }
    ]
    GridLayout {
        anchors.fill: parent
        anchors.margins: 10
        columns: 2

        InfoSlider {
            val: ComputerInfo.cpu
            text: "\uf4bc"
            visible: !ComputerInfo.loading && ComputerInfo.errorMessage === ""
        }

        InfoSlider {
            text: "\uefc5"
            val: ComputerInfo.memory
            visible: !ComputerInfo.loading && ComputerInfo.errorMessage === ""
        }

        Text {
            text: "Loading..."
            visible: ComputerInfo.loading
            anchors.centerIn: parent
            font.pixelSize: 20
            color: Colors.on_background
        }

        Text {
            text: ComputerInfo.errorMessage
            visible: ComputerInfo.errorMessage !== ""
            anchors.centerIn: parent
            font.pixelSize: 16
            color: Colors.error // Using the correct color from the singleton
            wrapMode: Text.WordWrap
        }
    }

    component InfoSlider: ColumnLayout {
        required property real val
        required property string text
        implicitWidth: 500
        implicitHeight: 300
        Layout.fillHeight: true
        Layout.preferredWidth: 10
        Layout.alignment: Qt.AlignLeft
        CoolProgressBar {
            Layout.fillHeight: true
            val: parent.val
            implicitWidth: 10
            Layout.alignment: Qt.AlignCenter
        }
        Text {
            text: parent.text
            color: Colors.on_background
            font.pixelSize: 20
            Layout.alignment: Qt.AlignCenter
        }
    }
}
