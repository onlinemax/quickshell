import QtQuick
import Quickshell
import Quickshell.Bluetooth
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Widgets
import qs
import qs.utils
import qs.widgets

Item {
    required property var properties
    readonly property real padding: Appearance.padding.little
    ListView {
        anchors.fill: parent
        model: Bluetooth.adapters
        delegate: Item {
            required property BluetoothAdapter modelData
            readonly property real rad: Appearance.radius.little
            width: parent.width - 2 * padding
            height: colLayout.height + 2 * padding
            anchors.horizontalCenter: parent.horizontalCenter
            ColumnLayout {
                id: colLayout
                readonly property real padding: Appearance.padding.medium
                width: parent.width - 2 * padding
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id: title
                    Layout.margins: padding
                    text: `${modelData.name} (${modelData.adapterId})`
                    color: Colors.on_primary_container
                    font.pixelSize: Appearance.fontSize.medium
                }
                RowLayout {
                    ToggleButton {
                        sourceURL: `${Quickshell.configDir}/images/bluetooth.svg`
                        toggle: modelData.enabled
                        onToggleChanged: modelData.enabled = toggle
                    }
                    ToggleButton {
                        sourceURL: `${Quickshell.configDir}/images/bluetooth_searching.svg`

                        toggle: modelData.discovering
                        onToggleChanged: modelData.discovering = toggle
                    }
                    ToggleButton {
                        sourceURL: `${Quickshell.configDir}/images/bluetooth_unlock.svg`
                        toggle: modelData.discoverable
                        onToggleChanged: modelData.discoverable = toggle
                    }
                }
                Text {
                    text: "Blutooth devices: "
                    font.pixelSize: Appearance.fontSize.little
                    color: Colors.on_primary_container
                }
                Repeater {
                    model: modelData.devices
                    BluetoothDeviceWidget {
                        required property BluetoothDevice modelData
                        device: modelData
                    }
                }
            }
        }
    }
    component ToggleButton: IconButton {
        id: button

        required property string sourceURL
        property bool toggle: false
        property color backgroundColor: 'transparent'

        toggled: toggle
        toggledColor: Colors.on_primary
        untoggledColor: Colors.outline
        option: "stroke"

        implicitWidth: Appearance.width.icon
        implicitHeight: Appearance.height.icon
        color: backgroundColor
        padding: 10
        radius: Appearance.radius.icon
        source: sourceURL

        onClicked: () => {
            toggle = !toggle;
        }

        states: [
            State {
                name: "toggled"
                when: toggle
                PropertyChanges {
                    button.backgroundColor: Colors.primary
                }
            }
        ]
    }
}
