import QtQuick
import Quickshell

Image {
    property bool toggled
    required property color toggledColor
    required property color untoggledColor
    required property string option
    required property string inFile
    readonly property string outToggledFile: {
        const fileName = inFile.substring(inFile.lastIndexOf("/") + 1, inFile.length - 4);
        return `${Quickshell.configDir}/images/generated/${fileName}_${toggledColor}.svg`.replace("#", "");
    }
    readonly property string outUntoggledFile: {
        const fileName = inFile.substring(inFile.lastIndexOf("/") + 1, inFile.length - 4);
        return `${Quickshell.configDir}/images/generated/${fileName}_${untoggledColor}.svg`.replace("#", "");
    }
    source: toggled ? outToggledFile : outUntoggledFile
    Component.onCompleted: {
        Quickshell.execDetached([`${Quickshell.configDir}/scripts/svgcolors`, inFile, option, toggledColor, outToggledFile]);
        Quickshell.execDetached([`${Quickshell.configDir}/scripts/svgcolors`, inFile, option, untoggledColor, outUntoggledFile]);
    }
}
