import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../.."
import "../../widgets"

Item {
    id: root
    required property var properties
    Scope {
        id: scope
        property var screenView: null
        property var screenViewObject: null
        property var currentSurface: null

        function createScreenView() {
            screenView = Qt.createComponent("../../ScreenViewSelector.qml");
            if (screenView.status != Component.Ready) {
                console.error("The file doesn't exist");
                return;
            }
            screenViewObject = screenView.createObject(scope);
            if (currentSurface != null) {
                screenViewObject.surface = currentSurface;
            }
            if (screenViewObject == null) {
                console.error("couldn't create the object");
            }
            screenViewObject.destroyClass.connect(deleteScreenView);
        }

        function deleteScreenView() {
            if (screenView == null)
                return;
            currentSurface = screenViewObject.surface;
            root.properties.menuOpen = true;
            screenViewObject.destroy();
            screenViewObject = null;
        }
    }
    RowLayout {
        Layout.preferredHeight: 50
        Layout.fillWidth: true

        CustomButton {
            Layout.preferredWidth: selectZoneIcon.implicitWidth + 10
            Layout.preferredHeight: selectZoneIcon.implicitHeight
            property bool toggled: false
            property bool hovered: false

            color: Qt.alpha(Colors.primary, 0.4)
            onClicked: () => {
                scope.createScreenView();
            }
            onEntered: () => hovered = true
            onExited: () => hovered = false

            Image {
                id: selectZoneIcon
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 10
                width: Math.max(height, dimensionText.width + 20)
                height: 30
                source: "../../images/screen_selection.svg"
                Text {
                    id: dimensionText
                    anchors.centerIn: parent
                    text: {
                        if (!scope.currentSurface) {
                            return "";
                        }
                        return `${scope.currentSurface.width}x${scope.currentSurface.height}`;
                    }
                    color: Colors.on_background
                }
            }

            ToolTip {
                parent: parent
                visible: parent.hovered
                text: "Select Capture Area"
            }
        }
    }
}
