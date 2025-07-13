import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs
import qs.widgets
import qs.utils

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
        function getDefaultFile() {
            const date = new Date();
            const year = date.getFullYear();
            const month = (date.getMonth() + 1).toString().padStart(2, "0");
            const day = date.getDate().toString().padStart(2, "0");
            const hour = date.getHours();
            const minutes = date.getMinutes();
            const seconds = date.getSeconds();
            const home_directory = Quickshell.env("HOME");

            return `${home_directory}/Videos/Recordings/recording-${year}-${month}-${day}-${hour}-${minutes}-${seconds}.mp4`;
        }
        function startRecording(area, outputPath) {
            if (outputPath == null || outputPath == "") {
                outputPath = getDefaultFile();
            }

            let com;
            if (area == null)
                com = ["gpu-screen-recorder", "-w", "screen", "-f", "60", "-o", outputPath];
            else {
                const region = `${area.width}x${area.height}+${area.x}+${area.y}`;
                com = ["gpu-screen-recorder", "-w", "region", "-region", region, "-f", "60", "-o", outputPath];
            }
            recordProcess.command = com;
            recordProcess.running = true;
        }
        function stopRecording() {
            recordProcess.signal(2); // SIGINT
        }

        Process {
            id: recordProcess
        }
    }

    GridLayout {
        anchors.fill: parent
        columns: 2
        rowSpacing: Appearance.padding.little
        columnSpacing: Appearance.padding.little
        Text {
            text: "Screen recorder"
            Layout.columnSpan: 2
            color: Colors.on_background
            font.pixelSize: 16
        }
        CustomButton {
            Layout.fillWidth: true
            Layout.preferredHeight: playIcon.height + Appearance.padding.little
            color: stopIcon.visible ? Colors.on_error : Colors.primary
            radius: Appearance.radius.icon / 2

            onClicked: () => {
                playIcon.visible = !playIcon.visible;
                stopIcon.visible = !stopIcon.visible;
                if (!playIcon.visible) {
                    scope.startRecording(scope.currentSurface, pathText.text);
                } else {
                    scope.stopRecording();
                }
            }
            ImageColor {
                id: playIcon
                width: 30
                height: width
                toggledColor: 'white'
                untoggledColor: 'white'
                toggled: true
                option: "stroke"
                inFile: `${Quickshell.configDir}/images/play.svg`
                anchors.centerIn: parent
            }
            ImageColor {
                id: stopIcon
                width: 30
                height: 30
                toggledColor: 'white'
                untoggledColor: Colors.error
                toggled: true
                option: "stroke"
                inFile: `${Quickshell.configDir}/images/stop.svg`
                visible: false
                anchors.centerIn: parent
            }
        }
        CustomButton {
            Layout.fillWidth: true
            Layout.preferredHeight: selectZoneIcon.height + Appearance.padding.little
            radius: Appearance.radius.icon / 2
            property bool toggled: false
            property bool hovered: false

            color: Colors.primary
            onClicked: () => {
                scope.createScreenView();
            }
            onEntered: () => hovered = true
            onExited: () => hovered = false

            Image {
                id: selectZoneIcon
                anchors.centerIn: parent
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
                    color: 'white'
                }
            }

            ToolTip {
                parent: parent
                visible: parent.hovered
                text: "Select Capture Area"
            }
        }
        CustomButton {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            color: Colors.primary
            radius: Appearance.radius.icon / 2
            Text {
                color: 'white'
                text: "Reset screen"
                anchors.centerIn: parent
                font.pixelSize: 16
            }
            onClicked: () => {
                scope.currentSurface = null;
            }
        }
        RowLayout {
            Layout.columnSpan: 2
            Layout.preferredHeight: 30

            Process {
                id: chooserProcess
                running: false
                command: [`${Quickshell.configDir}/scripts/file_chooser`]
                stdout: SplitParser {
                    onRead: message => {
                        if (message != "") {
                            pathText.text = message;
                            properties.menuOpen = true;
                        }
                    }
                }
            }
            CustomButton {
                radius: Appearance.radius.icon / 2
                color: Colors.primary

                Layout.preferredWidth: 30
                Layout.preferredHeight: 30

                onEntered: () => {
                    color = Colors.outline;
                }
                onExited: () => {
                    color = Colors.primary;
                }
                onClicked: () => {
                    chooserProcess.running = true;
                }
                ImageColor {
                    anchors.centerIn: parent
                    width: parent.width - Appearance.padding.little
                    height: parent.height - Appearance.padding.little
                    toggledColor: 'white'
                    untoggledColor: 'white'
                    option: "stroke"
                    inFile: `${Quickshell.configDir}/images/file_plus.svg`
                }
            }
            Rectangle {
                radius: Appearance.radius.icon / 2
                color: Colors.primary

                Layout.fillWidth: true
                Layout.preferredHeight: 30

                Text {
                    id: pathText
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: Appearance.padding.icon
                    color: 'white'
                }
            }
        }

        Item {
            Layout.columnSpan: 2
            Layout.fillHeight: true
        }
    }
}
