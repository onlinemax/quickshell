pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: info
    property double cpu
    property int temperature
    property double memory
    property bool loading: true
    property string errorMessage: ""

    Process {
        command: [`${Quickshell.shellRoot}/scripts/monitor`]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: message => {
                if (info.loading) {
                    info.loading = false;
                }
                if (info.errorMessage !== "") {
                    info.errorMessage = "";
                }

                const [cpu, temperature, memory] = message.split(" ");
                info.cpu = Number.parseFloat(cpu);
                info.temperature = Number.parseInt(temperature);
                info.memory = Number.parseFloat(memory);
            }
        }
        stderr: SplitParser {
            splitMarker: "\n"
            onRead: message => {
                if (info.loading) {
                    info.loading = false;
                }
                info.errorMessage = message;
                console.error("Monitor Process Error:", message)
            }
        }
    }
}
