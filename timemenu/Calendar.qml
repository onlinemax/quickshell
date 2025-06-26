pragma ComponentBehavior: Bound
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick
import Quickshell.Io
import Quickshell
import ".."

ColumnLayout {
    id: colLayout
    property date currentDate: new Date()
    readonly property int padding: 10
    property var monthCases

    spacing: 3
    anchors.margins: padding
    anchors.top: parent.top

    Item {
        id: titleBar
        implicitWidth: parent.width
        implicitHeight: 30
        Layout.alignment: Qt.AlignTop
        readonly property int radius: 10

        Text {
            id: title
            anchors.left: parent.left
            anchors.leftMargin: padding + parent.radius
            text: Qt.formatDateTime(colLayout.currentDate, "MMM yyyy")
            color: Colors.on_background
            font.family: "Inter"
            font.pointSize: 13
        }
        RowLayout {
            anchors.right: parent.right
            anchors.rightMargin: padding
            Button {
                implicitWidth: 23
                implicitHeight: 18
                background: Rectangle {
                    anchors.fill: parent
                    color: Colors.secondary
                    radius: 4
                    Image {
                        source: "../images/left.svg"
                        anchors.centerIn: parent
                        width: 15
                        height: 15
                    }
                }
                onClicked: {
                    colLayout.currentDate.setMonth(colLayout.currentDate.getMonth() - 1);
                    gridCalendar.getMonthData();
                }
            }
            Button {
                implicitWidth: 23
                implicitHeight: 18
                onClicked: {
                    colLayout.currentDate.setMonth(colLayout.currentDate.getMonth() + 1);
                    gridCalendar.getMonthData();
                }
                background: Rectangle {
                    anchors.fill: parent
                    color: Colors.secondary
                    radius: 4
                }
                Image {
                    source: "../images/right.svg"
                    anchors.centerIn: parent
                    width: 15
                    height: 15
                }
            }
        }
    }

    Grid {
        id: gridCalendar
        Layout.alignment: Qt.AlignCenter | Qt.AlignTop
        columns: 7
        Repeater {
            model: colLayout.monthCases.length
            Rectangle {
                required property int index
                readonly property var monthCase: colLayout.monthCases[index]
                implicitWidth: (colLayout.width - 2 * 6) / 7
                implicitHeight: implicitWidth / (monthCase.dayName ? 2 : 1)
                color: 'transparent'
                Text {
                    anchors.centerIn: parent
                    text: parent.monthCase.dayName ? parent.monthCase.week : parent.monthCase.day
                    color: parent.monthCase.hidden ? Colors.on_secondary : Colors.on_background
                    font.bold: parent.monthCase.dayName
                    font.family: "Roboto"
                }
            }
        }

        function getMonthData() {
            const date = new Date(colLayout.currentDate.getFullYear(), colLayout.currentDate.getMonth(), 1);
            const year = date.getFullYear();
            const month = date.getMonth();
            const isTodayMonth = new Date().getMonth() == month && new Date().getFullYear() == year;
            const isLeap = year % 100 == 0 ? (year % 400 == 0) : (year % 4 == 0);
            const daysInMonths = [31, isLeap ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
            const daysInMonth = daysInMonths[month];
            const daysInPreviousMonth = daysInMonths[month - 1 == -1 ? 11 : month - 1];
            const startDay = (date.getDay() == 0) ? 6 : date.getDay() - 1;
            const months = ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map(x => ({
                        week: x,
                        hidden: false,
                        dayName: true
                    }));
            const endDay = (startDay + daysInMonth - 1) % 7;

            for (let i = daysInPreviousMonth - startDay + 1; i <= daysInPreviousMonth; i++) {
                months.push({
                    day: i,
                    hidden: true,
                    dayName: false
                });
            }

            for (let day = 1; day <= daysInMonth; day++) {
                months.push({
                    day: day,
                    hidden: false,
                    dayName: false,
                    today: isTodayMonth ? (day == new Date().getDate()) : false
                });
            }

            for (let i = endDay + 1, day = 1; i % 7 != 0; i++, day++) {
                months.push({
                    day: day,
                    hidden: true,
                    dayName: false
                });
            }

            colLayout.monthCases = [...months];
        }
        Component.onCompleted: {
            getMonthData();
        }
    }
    // TODO: Change the following process to `Quickshell.execDetached`
    Process {
        running: true
        command: [`${Quickshell.shellRoot}/scripts/svgcolors`, `${Quickshell.shellRoot}/images/right.svg`, "stroke", Colors.on_secondary]
    }
    Process {
        running: true
        command: [`${Quickshell.shellRoot}/scripts/svgcolors`, `${Quickshell.shellRoot}/images/left.svg`, "stroke", Colors.on_secondary]
    }
}
