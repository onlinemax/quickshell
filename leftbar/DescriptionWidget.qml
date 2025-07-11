import QtQuick.Layouts
import QtQuick
import Quickshell.Hyprland
import Quickshell.Io
import ".."

RowLayout {

    function setSrcImage(src) {
        image.source = src;
    }
    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (!event.name.endsWith("v2"))
                getActiveClient.running = true;
        }
    }

    Process {
        id: getActiveClient
        command: ["hyprctl", "activewindow", "-j"]
        stdout: StdioCollector {
            onStreamFinished: () => {
                const out = JSON.parse(this.text);
                let title = out.title;
                setSrcImage("");
                if (title == undefined) {
                    description.text = "";
                    return;
                }
                switch (out.class) {
                case "Chromium":
                case "chromium":
                    title = title.substring(0, title.lastIndexOf(" - Chromium"));
                    setSrcImage("../images/chromium.png");
                    break;
                case "vesktop":
                    title = title.substring(title.indexOf("Discord | ") + 10);
                    setSrcImage("../images/discord.svg");
                    break;
                case "Alacritty":
                    setSrcImage("../images/alacritty.png");
                    break;
                }
                if (title.startsWith("nvim")) {
                    setSrcImage("../images/nvim.png");
                }
                if (title.startsWith("max@archlinux:")) {
                    title = title.substring(14);
                    title.trim();
                }

                if (title.length > 60) {
                    title = title.substring(57) + "...";
                }

                description.text = title;
            }
        }
    }

    Image {
        id: image
        property int padding: 4
        Layout.preferredWidth: this.source != "" ? 15 : 0
        Layout.preferredHeight: this.source != "" ? 15 : 0
    }

    Text {
        id: description
        color: Colors.on_background
        text: ""
    }
}
