import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import "./utils/"

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    color: 'transparent'

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    property rect surface: Qt.rect(width / 2, height / 2, 1, 1)
    signal destroyClass

    onSurfaceChanged: {
        canvas.requestPaint();
    }

    MouseArea {
        id: mArea
        anchors.fill: parent
        property int startingPositionX: -1
        property int startingPositionY: -1
        property int endingPositionX: -1
        property int endingPositionY: -1
        onPositionChanged: {
            if (startingPositionX == -1 && startingPositionY == -1) {
                startingPositionX = mouseX;
                startingPositionY = mouseY;
                return;
            }
            endingPositionX = mouseX;
            endingPositionY = mouseY;
            canvas.requestPaint();
        }
        onReleased: {
            const x1 = Math.min(startingPositionX, endingPositionX);
            const x2 = Math.max(startingPositionX, endingPositionX);
            const y1 = Math.min(startingPositionY, endingPositionY);
            const y2 = Math.max(startingPositionY, endingPositionY);

            surface.x = x1;
            surface.y = y1;
            surface.width = x2 - x1;
            surface.height = y2 - y1;

            startingPositionX = -1;
            startingPositionY = -1;
            endingPositionX = -1;
            endingPositionY = -1;
        }

        Rectangle {
            anchors.fill: parent
            color: 'transparent'
            Canvas {
                id: canvas
                anchors.fill: parent
                onPaint: {
                    const context = getContext("2d");
                    context.reset();
                    context.lineWidth = 2;
                    context.textAlign = "start";
                    context.fillStyle = Qt.alpha(Colors.background, 0.5);
                    // Make makground
                    context.fillRect(0, 0, parent.width, parent.height);

                    let x, y, width, height;

                    if (mArea.startingPositionX == -1 || mArea.startingPositionY == -1 || mArea.endingPositionX == -1 || mArea.endingPositionY == -1) {
                        x = surface.x;
                        y = surface.y;
                        width = surface.width;
                        height = surface.height;
                    } else {
                        x = Math.min(mArea.startingPositionX, mArea.endingPositionX);
                        y = Math.min(mArea.startingPositionY, mArea.endingPositionY);
                        width = Math.max(mArea.startingPositionX, mArea.endingPositionX) - x;
                        height = Math.max(mArea.startingPositionY, mArea.endingPositionY) - y;
                    }
                    const tooltipText = `${width}x${height}`;
                    context.strokeRect(x, y, width, height);
                    context.clearRect(x, y, width, height);
                    context.fillStyle = Colors.on_background;
                    context.fillText(tooltipText, x + width + 5, y + height + 5);
                }
            }
        }
    }
    Button {
        width: Appearance.width.icon
        height: Appearance.height.icon
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 0
        }
        Behavior on anchors.bottomMargin {
            NumberAnimation {
                duration: 500
            }
        }
        onClicked: {
            root.destroyClass();
        }
        background: Rectangle {
            anchors.fill: parent
            color: 'white'
        }
        Component.onCompleted: anchors.bottomMargin = 20
    }
}
