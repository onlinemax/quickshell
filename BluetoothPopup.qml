import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

PopupWindow {
    id: popup
    visible: false
    color: "transparent"

    width: 430
    implicitHeight: 100
    property var parentWindow

    anchor.window: parentWindow
    anchor.rect.x: parentWindow.width / 2
    anchor.rect.y: 100

    Rectangle {
        id: outerWrapper
        anchors.fill: parent
        radius: 3
        color: "#0a0a0a"

        Column {
            id: mainContent
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // ListView for adapters
            ListView {
                id: adapterList
                model: Bluetooth.adapters
                width: parent.width
                height: Math.min(adapterList.contentHeight, 300) // max height, scroll if needed
                clip: true

                delegate: Column {
                    width: parent.width
                    required property BluetoothAdapter modelData
                    spacing: 5

                    Rectangle {
                        width: 430
                        implicitHeight: 45
                        radius: 3
                        color: {
                            switch (modelData.state) {
                            case BluetoothAdapterState.Blocked:
                                return "#ffaaaa";
                                break;
                            case BluetoothAdapterState.Disabled:
                                return "#ffcccc";
                                break;
                            case BluetoothAdapterState.Disabling:
                                return "#ffe699";
                                break;
                            case BluetoothAdapterState.Enabled:
                                return "#decde3";
                                break;
                            case BluetoothAdapterState.Enabling:
                                return "#99ff99";
                                break;
                            default:
                                return "gray";
                                break;
                            }
                        }

                        Image {
                            width: 24
                            height: 24
                            fillMode: Image.PreserveAspectFit
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 10
                            sourceSize: Qt.size(width, height)
                            source: {
                                switch (modelData.state) {
                                case BluetoothAdapterState.Enabled:
                                    Qt.resolvedUrl("./testimages/bluetooth-connected.svg");
                                    break;
                                case BluetoothAdapterState.Disabled:
                                    Qt.resolvedUrl("./testimages/bluetooth.svg");
                                    break;
                                case BluetoothAdapterState.Enabling:
                                    Qt.resolvedUrl("./testimages/bluetooth.svg");
                                    break;
                                case BluetoothAdapterState.Disabling:
                                    Qt.resolvedUrl("./testimages/bluetooth.svg");
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
