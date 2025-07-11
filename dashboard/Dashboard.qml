pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."
import "../utils"

Rectangle {
    id: wrapper
    readonly property int padding: Appearance.padding.medium
    property bool shown: properties.dashboardOpen
    required property var properties
    radius: Appearance.radius.medium
    implicitWidth: Appearance.width.large + 2 * padding
    implicitHeight: Appearance.height.medium + 2 * padding
    y: -wrapper.height
    color: Colors.background
    onShownChanged: {
        ComputerInfo.running = this.shown;
    }

    states: [
        State {
            name: "notvisible"
            when: !wrapper.shown
            PropertyChanges {
                wrapper {
                    y: -wrapper.height
                    visible: false
                }
            }
        },
        State {
            name: "visible"
            when: wrapper.shown
            PropertyChanges {
                wrapper {
                    y: 40
                    visible: true
                }
            }
        }
    ]
    transitions: [
        Transition {
            from: "notvisible"
            to: "visible"
            SequentialAnimation {
                PropertyAction {
                    target: wrapper
                    property: "visible"
                    value: true
                }
                NumberAnimation {
                    target: wrapper
                    property: "y"
                    duration: Appearance.duration.medium
                    easing.type: Easing.InOutQuad
                }
            }
        },
        Transition {
            from: "visible"
            to: "notvisible"
            SequentialAnimation {
                NumberAnimation {
                    target: wrapper
                    property: "y"
                    duration: Appearance.duration.medium
                    easing.type: Easing.InOutQuad
                }
                PropertyAction {
                    target: wrapper
                    property: "visible"
                    value: false
                }
            }
        }
    ]
    RowLayout {
        anchors.fill: parent
        anchors.margins: Appearance.margin.medium
        spacing: 10

        Resource {
            Layout.fillHeight: true
            Layout.fillWidth: true
            title: `${Math.round(ComputerInfo.temperature / 1000)} \u00b0C`
            info: "CPU temp"
            percentage: (ComputerInfo.temperature - 20 * 1000) / (60 * 1000) // Between 20 and 100 thousands miliCelcius
            usage: ComputerInfo.cpu / 100
        }
        Resource {
            Layout.fillHeight: true
            Layout.fillWidth: true
            title: `Memory`
            info: ""
            percentage: 1
            usage: ComputerInfo.memory / 100
        }
    }

    component InfoSlider: ColumnLayout {
        required property real val
        required property string text
        Layout.fillHeight: true
        Layout.preferredWidth: 10
        Layout.alignment: Qt.AlignLeft
        CoolProgressBar {
            Layout.fillHeight: true
            val: parent.val
            implicitWidth: 10
            Layout.alignment: Qt.AlignCenter
        }
        Text {
            text: parent.text
            color: Colors.on_background
            font.pixelSize: Appearance.fontSize.little
            Layout.alignment: Qt.AlignCenter
        }
    }
    component Resource: Canvas {

        required property string title
        required property string info
        required property real percentage
        required property real usage

        onPercentageChanged: requestPaint()
        onUsageChanged: requestPaint()
        Behavior on percentage {
            NumberAnimation {
                duration: Appearance.duration.little
            }
        }
        Behavior on usage {
            NumberAnimation {
                duration: Appearance.duration.little
            }
        }
        TextMetrics {
            id: textMetrics
            font.family: "Roboto"
            elide: Text.ElideNone
        }
        onPaint: {
            function toRadians(degrees) {
                return Math.PI * degrees / 180;
            }
            // Some settings
            const ctx = getContext("2d");
            const lineWidth = 10;
            const bg1 = Colors.on_secondary;
            const bg2 = Colors.secondary;
            const hidden = Colors.outline;
            const txt = Colors.primary;
            const titleFontSize = Appearance.fontSize.little;
            const infoFontSize = Appearance.fontSize.icon;
            const usageTextFontSize = Appearance.fontSize.little;
            const usageLabelFontSize = Appearance.fontSize.icon;

            const startBelowSegment = toRadians(55);
            const endBelowSegment = toRadians(215);
            const startUpSegment = toRadians(35);
            const endUpSegment = -toRadians(125);

            const {
                width: w,
                height: h
            } = this.canvasSize;
            const r = (Math.min(w, h) - lineWidth - 2 * Appearance.padding.little) / 2;

            ctx.reset();

            ctx.lineWidth = lineWidth;
            ctx.lineCap = 'round';
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";

            // Arc Part

            // Below Arc
            ctx.beginPath();
            ctx.strokeStyle = bg1;
            ctx.arc(Math.floor(w / 2), Math.floor(h / 2), r, startBelowSegment, endBelowSegment, false);
            ctx.stroke();
            ctx.closePath();

            // Below Progression
            ctx.beginPath();
            ctx.strokeStyle = Colors.secondary;
            ctx.arc(Math.floor(w / 2), Math.floor(h / 2), r, startBelowSegment, startBelowSegment + (endBelowSegment - startBelowSegment) * percentage, false);
            ctx.stroke();
            ctx.closePath();

            // Top Arc
            ctx.beginPath();
            ctx.strokeStyle = Colors.on_primary;
            ctx.arc(Math.floor(w / 2), Math.floor(h / 2), r, startUpSegment, endUpSegment, true);
            ctx.stroke();
            ctx.closePath();

            // Top progression
            ctx.beginPath();
            ctx.strokeStyle = Colors.primary;
            ctx.arc(Math.floor(w / 2), Math.floor(h / 2), r, startUpSegment, startUpSegment + (endUpSegment - startUpSegment) * usage, true);
            ctx.stroke();
            ctx.closePath();

            // Text Part

            // Get measurements of title
            ctx.font = `${titleFontSize}px Roboto`;
            textMetrics.font.pixelSize = titleFontSize;
            textMetrics.text = title;
            const titleHeight = textMetrics.tightBoundingRect.height;

            // Get measurements of info
            ctx.font = `${infoFontSize}px Roboto`;
            textMetrics.font.pixelSize = infoFontSize;
            textMetrics.text = info;
            const infoHeight = textMetrics.tightBoundingRect.height;

            // Get measurement of usage
            const usageText = `${Math.round(usage * 100)}%`;
            const usageLabel = "usage";

            // the text part of the usage
            textMetrics.font.pixelSize = usageTextFontSize;
            textMetrics.text = usageText;
            const usageTextHeight = textMetrics.tightBoundingRect.height;

            // The label part of the usage
            textMetrics.font.pixelSize = usageLabelFontSize;
            textMetrics.text = usageLabel;
            const usageLabelHeight = textMetrics.tightBoundingRect.height;

            // Draw both size
            const accumHeightTitle = infoHeight + titleHeight;
            const accumHeightUsage = usageTextHeight + usageLabelHeight;
            const accumHeight = accumHeightTitle + accumHeightUsage;

            // uasge
            const usageY = (h - accumHeight) / 2;
            const usageX = w / 2 + Appearance.padding.little;

            // Draw usageTextTExt
            ctx.font = `${usageTextFontSize}px Roboto`;
            ctx.fillStyle = Colors.primary;
            ctx.fillText(usageText, usageX, usageY);

            // Draw usageLabelText
            ctx.font = `${usageLabelFontSize}px Roboto`;
            ctx.fillStyle = hidden;
            ctx.fillText(usageLabel, usageX, usageY + usageTextHeight);

            // info
            const infoY = usageY + accumHeightUsage + Appearance.padding.medium;
            const infoX = w / 2 - Appearance.padding.little;

            ctx.font = `${titleFontSize}px Roboto`;
            ctx.fillStyle = Colors.secondary;
            ctx.fillText(title, w / 2, infoY);

            ctx.font = `${infoFontSize}px Roboto`;
            ctx.fillStyle = hidden;
            ctx.fillText(info, infoX, infoY + titleHeight);
        }
    }
}
