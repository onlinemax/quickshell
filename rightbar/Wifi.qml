import QtQuick
import "../utils/"
import ".."

Item {
    id: root

    readonly property int padding: 5
    readonly property list<string> wifiStrengthIcons: ["\udb82\udd1f", "\udb82\udd22", "\udb82\udd25", "\udb82\udd28"]
    property string wifiIcon

    implicitWidth: wifiText.width + 2 * padding

    function getWifiIcon() {
        const rate = Network.activeNetwork.rate;

        if (rate < 25) {
            return wifiStrengthIcons[0];
        }
        if (rate >= 25 && rate < 50) {
            return wifiStrengthIcons[1];
        }
        if (rate >= 50 && rate < 75) {
            return wifiStrengthIcons[2];
        }
        if (rate >= 75) {
            return wifiStrengthIcons[3];
        }
        return "\udb82\udd2d";
    }
    Text {
        id: wifiText
        anchors.centerIn: parent
        text: parent.wifiIcon
        color: Colors.on_background
    }
    states: [
        State {
            name: "disconnected"
            when: Network.activeNetwork == null
            PropertyChanges {
                root {
                    wifiIcon: "\udb82\udd2d"
                }
            }
        },
        State {
            name: "active"
            when: Network.activeNetwork != null
            PropertyChanges {
                root {
                    wifiIcon: getWifiIcon()
                }
            }
        }
    ]
}
