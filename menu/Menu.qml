import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs
import qs.utils
import qs.menu.home
import qs.menu.bluetooth
import qs.widgets

RowLayout {
    id: root
    anchors.bottom: parent.bottom
    anchors.fill: parent
    spacing: 5
    anchors.margins: Appearance.margin.little
    required property var properties

    Column {
        id: bar
        property int currentIndex: 0
        Layout.fillHeight: true
        Layout.preferredWidth: Appearance.width.icon - 10
        spacing: 10
        ListModel {
            id: tabsData
            ListElement {
                imageSrc: `images/house.svg`
                index: 0
            }
            ListElement {
                imageSrc: `images/musical_note.svg`
                index: 1
            }
            ListElement {
                imageSrc: `images/bluetooth.svg`
                index: 2
            }
        }

        Repeater {
            model: tabsData
            Button {
                required property string imageSrc
                required property int index

                anchors.horizontalCenter: bar.horizontalCenter
                implicitWidth: bar.width
                implicitHeight: bar.width
                onClicked: bar.currentIndex = index

                background: Rectangle {
                    color: bar.currentIndex == parent.index ? Qt.alpha(Colors.primary_container, 0.4) : 'transparent'
                    anchors.fill: parent
                    radius: 5
                    ImageColor {
                        readonly property int padding: Appearance.padding.icon
                        toggledColor: Colors.on_primary_container
                        untoggledColor: Colors.outline
                        option: "stroke"
                        inFile: `${Quickshell.configDir}/${imageSrc}`
                        width: parent.width - 2 * padding
                        toggled: bar.currentIndex == index
                        height: width
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        property int currentIndex: bar.currentIndex
        property int previousIndex: currentIndex
        clip: true

        onHeightChanged: {
            showIndex(currentIndex);
        }

        function showIndex(index: int) {
            children[index].implicitHeight = height;
        }

        onCurrentIndexChanged: {
            if (!children[currentIndex]) {
                return;
            }
            children[currentIndex].implicitHeight = height;
            if (currentIndex != previousIndex)
                children[previousIndex].implicitHeight = 0;
            // The order is important for the following 4 lines of code
            children[currentIndex].anchors.bottom = undefined;
            children[previousIndex].anchors.top = undefined;
            children[currentIndex].anchors.top = this.top;
            children[previousIndex].anchors.bottom = this.bottom;

            previousIndex = currentIndex;
        }
        Tab {
            Home {
                properties: root.properties

                anchors.fill: parent
            }
        }
        Tab {}
        Tab {
            BluetoothTab {
                properties: root.properties
                anchors.fill: parent
            }
        }
    }
    component Tab: Item {
        implicitWidth: parent.width
        implicitHeight: 0
        visible: implicitHeight > 0
        clip: true
        Behavior on implicitHeight {
            NumberAnimation {
                duration: Appearance.duration.little
                easing.type: Easing.InOutQuad
            }
        }
    }
}
