import QtQuick.Layouts
import QtQuick
import Quickshell.Hyprland
import Quickshell.Io
import ".."

RowLayout {

    function setSrcImage(src) {
        image.source = src;
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
        text: {
            if (Hyprland.activeToplevel == null) {
                return "";
            }
            let title = Hyprland.activeToplevel.title;
            const appId = Hyprland.activeToplevel.wayland.appId;
            setSrcImage("");
            switch (appId) {
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

            return title;
        }
    }
}
