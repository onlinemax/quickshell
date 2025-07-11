import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import "../.."
import "../../utils/"
import "../../widgets/"

Item {
    required property BluetoothDevice device
    Layout.fillWidth: true
    Layout.preferredHeight: colLayout.implicitHeight
    Rectangle {
        border.color: Colors.outline
        border.width: 2
        color: 'transparent'
        radius: Appearance.radius.little
        anchors.fill: parent
        ColumnLayout {
            id: colLayout
            anchors.fill: parent
            anchors.margins: 10
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: Appearance.height.icon
                Layout.alignment: Qt.AlignTop
                ImageColor {
                    id: icon
                    inFile: `${Quickshell.configDir}/images/device.svg`
                    toggledColor: Colors.on_background
                    untoggledColor: Colors.outline // this won't we be used
                    toggled: true
                    option: "stroke"
                    Layout.preferredWidth: Appearance.width.icon / 2
                    Layout.preferredHeight: Appearance.height.icon / 2
                }
                Text {
                    text: device.name
                    color: Colors.on_background
                }
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    color: Colors.on_background
                    text: device.batteryAvailable ? `\uf242 ${device.battery}%` : ""
                }
                IconButton {
                    padding: Appearance.padding.icon
                    source: `${Quickshell.configDir}/images/elipsis-vertical.svg`
                    radius: Appearance.radius.icon
                    toggledColor: Colors.on_background
                    untoggledColor: Colors.background
                    toggled: true
                    color: 'transparent'
                    option: "stroke"
                    Layout.preferredWidth: Appearance.width.icon * 2 / 3
                    Layout.preferredHeight: Appearance.height.icon * 2 / 3

                    onEntered: () => {
                        color = Colors.on_primary_container;
                        toggled = false;
                    }
                    onClicked: () => {
                        const toggle = menu.visible;
                        menu.visible = !toggle;
                        menu.x = this.x - menu.width + this.width;
                        menu.y = this.y - this.width - 50 - this.height;
                    }
                    onExited: () => {
                        color = 'transparent';
                        toggled = true;
                    }
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Item {
                    Layout.fillWidth: true
                }
                CustomButton {
                    Layout.preferredWidth: Appearance.width.little
                    Layout.preferredHeight: Appearance.height.icon / 2
                    color: Colors.primary
                    radius: Appearance.radius.icon
                    onClicked: () => {
                        if (device.pairing) {
                            device.cancelPair();
                            return;
                        }
                        if (device.paired) {
                            device.forget();
                            return;
                        }
                        device.pair();
                    }
                    Text {
                        anchors.centerIn: parent
                        text: device.pairing ? "cancel pairing" : (device.paired ? "unpair" : "pair")
                        color: Colors.on_primary
                    }
                }
                CustomButton {
                    Layout.preferredWidth: Appearance.width.little
                    Layout.preferredHeight: Appearance.height.icon / 2
                    color: Colors.primary
                    radius: Appearance.radius.icon
                    onClicked: () => {
                        switch (device.state) {
                        case BluetoothDeviceState.Connected:
                            device.disconnect();
                            break;
                        case BluetoothDeviceState.Disconnected:
                            device.connect();
                            break;
                        case BluetoothDeviceState.Connecting:
                            device.disconnect();
                            break;
                        case BluetoothDeviceState.Disconnecting:
                            device.connect();
                            break;
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: {
                            switch (device.state) {
                            case BluetoothDeviceState.Connected:
                                return "disconnect";
                                break;
                            case BluetoothDeviceState.Disconnected:
                                return "connect";
                                break;
                            case BluetoothDeviceState.Connecting:
                                return "cancel";
                                break;
                            case BluetoothDeviceState.Disconnecting:
                                return "cancel";
                                break;
                            }
                        }
                        color: Colors.on_primary
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: 'white'
            }
        }

        WrapperRectangle {
            id: menu
            visible: false
            margin: Appearance.margin.little
            implicitWidth: Appearance.width.little * 1.2
            radius: Appearance.radius.icon
            color: Colors.background
            border.width: 2
            border.color: Colors.primary

            ColumnLayout {
                spacing: 0
                MenuItem {
                    text: "Disconnect"
                }
                MenuItem {
                    text: "Help me"
                }
                MenuItem {
                    text: "Kill me"
                }
            }
        }
    }
    component MenuItem: CustomButton {
        required property string text
        Layout.preferredHeight: Appearance.height.icon * 2 / 3
        Layout.fillWidth: true
        color: 'transparent'
        onEntered: () => {
            color = Colors.secondary;
        }
        onExited: () => {
            color = 'transparent';
        }
        Text {
            color: Colors.on_background
            text: parent.text
        }
    }
}
