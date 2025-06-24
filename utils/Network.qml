pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: networkManager
    reloadableId: "networkManager"
    readonly property list<Network> networks: []
    readonly property Network activeNetwork: networks.find(network => network.active) ?? null
    Process {
        id: networkMonitoring
        running: true
        command: ["nmcli", "m"]
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: () => networkGathering.running = true
        }
    }
    Process {
        id: networkGathering
        running: false
        command: ["nmcli", "-g", "IN-USE,SIGNAL,RATE,SSID,BSSID", "device", "wifi"]
        stdout: StdioCollector {
            onStreamFinished: () => {
                const replacement = /ALLO/g;
                const pattern = /\\:/g;

                const newNetworks = this.text.split("\n").filter(text => text != "").map(line => {
                    line = line.replace(pattern, "ALLO");
                    const netAttributes = line.split(":");
                    return {
                        active: netAttributes[0] == "*",
                        signal: Number.parseInt(netAttributes[1]),
                        rate: Number.parseInt(netAttributes[2].replace("Mbit/s")),
                        ssid: netAttributes[3],
                        bssid: netAttributes[4].replace(replacement, ":")
                    };
                });

                const managerNetworks = networkManager.networks;
                managerNetworks.splice(0, managerNetworks.length).forEach(network => network.destroy()); // destroy everything
                for (const network of newNetworks) {
                    managerNetworks.push(placeholder.createObject(networkManager, {
                        networkInfo: network
                    }));
                }
            }
        }
    }

    component Network: QtObject {
        required property var networkInfo
        readonly property bool active: networkInfo.active
        readonly property int signal: networkInfo.signal
        readonly property int rate: networkInfo.rate
        readonly property string ssid: networkInfo.ssid
        readonly property string bssid: networkInfo.bssid
    }
    Component {
        id: placeholder
        Network {}
    }
}
