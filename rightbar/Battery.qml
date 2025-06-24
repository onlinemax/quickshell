import QtQuick
import Quickshell.Services.UPower
import ".."

Item {
    id: battery
    readonly property real batteryPercentage: Math.floor(UPower.displayDevice.percentage * 100)
    readonly property int padding: 5
    property string iconName: ""
    property string textColor: Colors.on_background
    readonly property var batteriesIcons: ["\udb80\udc8e", "\udb80\udc7a", "\udb80\udc7b", "\udb80\udc7c", "\udb80\udc7d", "\udb80\udc7e", "\udb80\udc7f", "\udb80\udc80", "\udb80\udc81", "\udb80\udc82", "\udb80\udc79"]
    readonly property var batteriesIconsCharging: ["\udb82\udc9f", "\udb82\udc9c", "\udb80\udc86", "\udb80\udc87", "\udb80\udc88", "\udb82\udc9d", "\udb80\udc89", "\udb82\udc9e", "\udb80\udc8a", "\udb80\udc8b", "\udb80\udc8b"]

    implicitWidth: batteryText.width + padding * 2
    state: UPowerDeviceState.toString(UPower.displayDevice.state)

    function getBatteryIcon(charging: bool): string {
        const index = Math.floor(batteryPercentage / 10);
        if (charging)
            return batteriesIconsCharging[index];
        return batteriesIcons[index];
    }

    Text {
        id: batteryText
        anchors.centerIn: parent
        color: textColor
        text: `${iconName}  ${batteryPercentage}%`
    }

    states: [
        State {
            name: "Charging"
            PropertyChanges {
                battery {
                    iconName: getBatteryIcon(true)
                }
            }
        },
        State {
            name: "Discharging"
            PropertyChanges {
                battery {
                    iconName: getBatteryIcon(false)
                }
            }
        }
    ]
}
