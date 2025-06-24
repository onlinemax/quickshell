import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import ".."

Button {

    required property var actionClicked
    onClicked: {
        actionClicked();
    }
    background: Rectangle {
        id: wrapper
        readonly property int padding: 5
        implicitWidth: root.width + 2 * padding
        implicitHeight: 25
        radius: Math.min(root.width, root.height) / 2
        color: Colors.background
        RowLayout {
            id: root
            spacing: 0
            anchors.centerIn: parent

            Wifi {
                implicitHeight: wrapper.implicitHeight
            }

            Sound {
                implicitHeight: wrapper.implicitHeight
            }

            Battery {
                implicitHeight: wrapper.implicitHeight
            }
        }
    }
}
