import QtQuick
import QtQuick.Effects

CustomButton {
    required property string source
    required property color toggledColor
    required property color untoggledColor
    required property bool toggled
    required property string option
    property real padding: 0
    ImageColor {
        id: icon

        inFile: parent.source
        toggledColor: parent.toggledColor
        untoggledColor: parent.untoggledColor
        option: parent.option
        toggled: parent.toggled

        width: parent.width - 2 * parent.padding
        height: parent.height - 2 * parent.padding
        anchors.centerIn: parent
    }
}
