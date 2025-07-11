import QtQuick
import QtQuick.Layouts

Rectangle {
    required property string name
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.preferredWidth: Layout.columnSpan
    Layout.preferredHeight: Layout.rowSpan
}
