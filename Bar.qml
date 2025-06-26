import Quickshell

import QtQuick
import Quickshell.Wayland

import "./leftbar/"
import "./centerbar/"
import "./rightbar/"
import "./timemenu/"
import "./utils"
import "./dashboard/"

Variants {
    model: Quickshell.screens
    Scope {
        property ShellScreen modelData
        readonly property int barHeight: 25

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
                x: 0
                y: bar.height
                width: win.width
                height: win.height
                intersection: Intersection.Xor
                regions: [
                    Region {
                        x: timemenu.x
                        y: timemenu.y
                        width: timemenu.width
                        height: timemenu.height
                        intersection: Intersection.Subtract
                    },
                    Region {
                        x: dashboard.x
                        y: dashboard.y
                        width: dashboard.width
                        height: dashboard.height
                        intersection: Intersection.Subtract
                    }
                ]
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
                    function toggleTimeMenu() {
                        timemenu.toggleMenu();
                    }

                    anchors.centerIn: parent
                    toggleMenu: toggleTimeMenu
                    time: Time.time
                    implicitWidth: 100
                    implicitHeight: 20
                }
                RightBar {
                    id: rightBar
                    anchors.right: parent.right
                    actionClicked: () => {
                        dashboard.shown = !dashboard.shown;
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // we can then set the window's screen to the injected property

            TimeMenu {
                id: timemenu
            }
            Dashboard {
                id: dashboard
                x: bar.width - dashboard.width
            }
        }
    }
}
