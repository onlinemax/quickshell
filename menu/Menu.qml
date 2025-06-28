import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

TabBar {
    id: bar
    width: parent.width
    anchors.bottom: parent.bottom
    anchors.fill: parent
    TabButton {
        text: qsTr("Home")
    }
    TabButton {
        text: qsTr("Discover")
    }
    TabButton {
        text: qsTr("Activity")
    }
}
