import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../.."
import "../../widgets"

ColumnLayout {
    id: root
    anchors.fill: parent
    required property var properties

    RowLayout {
        Layout.preferredHeight: 70
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            radius: 15
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color = Colors.primary;
                }
                onExited: {
                    parent.color = 'transparent';
                }
            }
            ClippingWrapperRectangle {
                id: icon
                radius: 15
                border.width: 2
                border.pixelAligned: true
                border.color: Colors.primary
                anchors {
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                IconImage {
                    implicitSize: 40
                    source: `file://${Quickshell.configDir}/images/logo.png`
                }
            }
            Text {
                anchors.left: icon.right
                anchors.leftMargin: 10
                anchors.verticalCenter: icon.verticalCenter
                font.family: "Roboto"
                font.pointSize: 16
                color: 'whitesmoke'
                text: "Hello onlinemax12"
            }
        }
        Meteo {
            Layout.preferredWidth: 70
            Layout.preferredHeight: 70
        }
    }
    RowLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        VolumeMixer {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        ScreenRecord {
            properties: root.properties
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
