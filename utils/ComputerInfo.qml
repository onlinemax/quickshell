pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: info
    property double cpu
    property int temperature
    property double memory
    Process {
        command: [`${Quickshell.shellRoot}/scripts/monitor`]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: message => {
                const [cpu, temperature, memory] = message.split(" ");
                info.cpu = Number.parseFloat(cpu);
                info.temperature = Number.parseInt(temperature);
                info.memory = Number.parseFloat(memory);
            }
        }
    }
}
