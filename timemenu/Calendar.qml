import QtQuick.Layouts
import QtQuick.Controls
import QtQuick
import ".."

ColumnLayout {
    id: colLayout
    property date currentDate: new Date()
    readonly property int padding: 10
    property var monthCases
    spacing: 5

    anchors.margins: padding
    anchors.fill: parent
    anchors.top: parent.top

    Item {

        implicitWidth: parent.width
        implicitHeight: 30
        Layout.alignment: Qt.AlignTop
        readonly property int radius: 10

        Button {
            anchors.left: parent.left
            anchors.leftMargin: padding + parent.radius / 2
            anchors.verticalCenter: parent.verticalCenter
            background: Rectangle {
                anchors.fill: parent
                color: '#c2c2c2'
                radius: parent.parent.radius
                Image {
                    source: "../images/left.svg"
                    anchors.centerIn: parent
                    width: 15
                    height: 15
                }
            }
            Layout.alignment: Qt.AlignLeft
            implicitWidth: 20
            implicitHeight: implicitWidth
            onClicked: {
                colLayout.currentDate.setMonth(colLayout.currentDate.getMonth() - 1);
                gridCalendar.getMonthData();
            }
        }
        Text {
            id: title
            anchors.centerIn: parent
            text: Qt.formatDateTime(colLayout.currentDate, "MMM yyyy")
            color: Colors.on_background
            Layout.alignment: Qt.AlignCenter
            font.family: "Inter"
            font.pointSize: 15
        }
        Button {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: 20
            implicitHeight: implicitWidth
            anchors.rightMargin: padding + parent.radius / 2
            onClicked: {
                colLayout.currentDate.setMonth(colLayout.currentDate.getMonth() + 1);
                gridCalendar.getMonthData();
            }
            Layout.alignment: Qt.AlignRight
            background: Rectangle {
                anchors.fill: parent
                color: '#c2c2c2'
                radius: parent.parent.radius
            }
            Image {
                source: "../images/right.svg"
                anchors.centerIn: parent
                width: 15
                height: 15
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
                readonly property var monthCase: colLayout.monthCases[index]
                implicitWidth: (colLayout.width - 2 * 6) / 7
                implicitHeight: implicitWidth / (monthCase.dayName ? 2 : 1)
                color: 'transparent'
                Text {
                    anchors.centerIn: parent
                    text: parent.monthCase.dayName ? parent.monthCase.week : parent.monthCase.day
                    color: parent.monthCase.hidden ? '#5664a5' : 'whitesmoke'
                    font.bold: parent.monthCase.dayName
                    font.family: "Roboto"
                }
            }
        }

        function getMonthData() {
            const date = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
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
}
