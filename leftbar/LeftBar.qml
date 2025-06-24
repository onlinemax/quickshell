import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."

Rectangle {
    readonly property int padding: 5
    width: leftBar.width + this.padding * 2
    height: leftBar.height + this.padding * 2
    bottomLeftRadius: leftBar.width / 2 + this.padding
    bottomRightRadius: leftBar.width / 2 + this.padding
    topLeftRadius: leftBar.width / 2 + this.padding
    topRightRadius: leftBar.width / 2 + this.padding
    anchors.topMargin: 20
    color: Colors.background
    RowLayout {
        id: leftBar
        anchors.centerIn: parent
        spacing: 10

        Repeater {
            // Layout
            model: Hyprland.workspaces
            WorkspaceButton {
                required property var modelData
                focusWorkspace: modelData.focused
                workspaceNumber: modelData.id
            }
        }
        DescriptionWidget {}
    }
}
