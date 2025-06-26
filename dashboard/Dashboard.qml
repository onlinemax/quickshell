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
    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

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
        Item {
            Layout.fillWidth: true
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
