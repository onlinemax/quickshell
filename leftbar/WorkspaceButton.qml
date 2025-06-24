import QtQuick.Controls
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick

import ".."

RoundButton {
    required property int workspaceNumber
    required property bool focusWorkspace

    background: Rectangle {
        radius: parent.radius
        color: Colors.primary
    }

    Behavior on Layout.preferredWidth {
        PropertyAnimation {
            duration: 140
            easing.type: Easing.InSine
        }
    }
    // Layout
    Layout.alignment: Qt.AlignLeft
    Layout.preferredWidth: Layout.preferredHeight * (this.focusWorkspace ? 4 : 1)
    Layout.preferredHeight: 10

    radius: Layout.preferredHeight / 2
    onClicked: () => Hyprland.dispatch(`workspace ${this.workspaceNumber}`)
}
