import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell
import "../../"

Item {
    Text {
        id: title
        font.pixelSize: 16
        text: 'Volume Mixer'
        color: Colors.on_background
        anchors.topMargin: 10
    }
    RowLayout {
        anchors.left: parent.left
        anchors.top: title.bottom
        height: parent.height - title.height - title.anchors.bottomMargin
        PwObjectTracker {
            id: tracker
            objects: []
        }
        NodeSlider {
            node: Pipewire.defaultAudioSink
            iconName: {
                if (node && node.ready && node.audio.muted) {
                    return `file://${Quickshell.configDir}/images/volume_muted.svg`;
                }
                return `file://${Quickshell.configDir}/images/volume.svg`;
            }
        }
        Repeater {
            model: Pipewire.linkGroups.values
            NodeSlider {
                required property PwLinkGroup modelData
                node: modelData.source
                iconName: {
                    let iconName = node.properties["application.icon-name"] ?? "";
                    let fallBackIconName = (node.properties["application.name"] ?? "").toLowerCase();

                    if (iconName.indexOf("-") != -1) {
                        iconName = iconName.substring(0, iconName.indexOf("-"));
                    }
                    let iconPath = Quickshell.iconPath(iconName, true);
                    if (iconPath != "")
                        return iconPath;
                    iconPath = Quickshell.iconPath(fallBackIconName, true);
                    return iconPath;
                }
            }
        }
    }
    component NodeSlider: ColumnLayout {
        id: layout
        required property PwNode node
        required property string iconName
        Slider {
            id: slider
            Layout.fillHeight: true
            Layout.preferredWidth: 30
            Layout.alignment: Qt.AlignHCenter
            background: Rectangle {
                readonly property int padding: 40
                implicitHeight: parent.height - padding
                implicitWidth: parent.width - padding
                radius: parent.width / 2
                color: Colors.on_secondary
            }
            handle: Rectangle {
                readonly property int padding: 2
                height: parent.width - 2 * padding
                width: parent.width - 2 * padding
                radius: parent.width / 2
                color: Colors.secondary
                y: slider.visualPosition * (slider.availableHeight - height - 2 * padding) + padding
                x: padding
                Text {
                    anchors.centerIn: parent
                    color: Colors.on_secondary
                    text: Math.round(slider.value * 100)
                }
            }

            orientation: Qt.Vertical
            from: 0
            to: 1
            value: node?.audio.volume ?? 0

            onValueChanged: {
                if (parent.node.ready)
                    parent.node.audio.volume = value;
            }

            Component.onCompleted: {
                tracker.objects.push(parent.node);
            }
        }
        IconImage {
            id: icon
            source: parent.iconName
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
        }
    }
}
