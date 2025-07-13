import Quickshell

import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland

import "./leftbar/"
import "./centerbar/"
import "./rightbar/"
import "./menu/"
import "./utils"
import "./dashboard/"

Variants {
    model: Quickshell.screens
    Scope {
        property ShellScreen modelData
        readonly property int barHeight: 25
        property var screenView: null

        PersistentProperties {
            id: properties
            reloadableId: "persistedStates"

            property bool dashboardOpen: false
            property bool menuOpen: false
            readonly property real dp: {
                return 2;
            }
        }

        PanelWindow {
            color: 'transparent'

            anchors {
                top: true
                left: true
                right: true
                bottom: false
            }
            exclusiveZone: barHeight
            implicitHeight: barHeight
            screen: modelData
        }
        PanelWindow {
            id: win

            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            color: 'transparent'
            implicitHeight: barHeight
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            mask: Region {
                Region {
                    item: bar
                }
                Region {
                    item: dashboard
                }
                Region {
                    item: menu
                }
            }

            Item {
                id: bar
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    leftMargin: 10
                    rightMargin: anchors.leftMargin
                }
                implicitHeight: barHeight
                implicitWidth: parent.width

                LeftBar {
                    implicitWidth: 100
                    implicitHeight: 20
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
                CenterBar {
                    function toggleMenu() {
                        properties.menuOpen = !properties.menuOpen;
                    }

                    anchors.centerIn: parent
                    toggleMenu: toggleMenu
                    time: Time.time
                    implicitWidth: 100
                    implicitHeight: 20
                }
                RightBar {
                    id: rightBar
                    anchors.right: parent.right
                    actionClicked: () => {
                        properties.dashboardOpen = !properties.dashboardOpen;
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // we can then set the window's screen to the injected property

            Wrapper {
                id: menu
                properties: properties
            }
            Dashboard {
                id: dashboard
                properties: properties
                x: bar.width - dashboard.width
            }
        }
    }
}
