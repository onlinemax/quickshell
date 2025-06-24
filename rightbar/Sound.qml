import QtQuick
import Quickshell.Services.Pipewire
import ".."

Item {
    id: root
    readonly property int padding: 5
    readonly property string volumeMuted: "\uf026"
    readonly property string volumeOff: "\ueee8"
    readonly property list<string> volumeIcons: ["\uf027", "\uf028"]
    property string volumeIcon

    implicitWidth: soundText.width + 2 * padding
    function getSound() {
        return Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100);
    }

    function getIcon() {
        const muted = Pipewire.defaultAudioSink?.audio.muted ?? true;
        const volume = getSound();
        return muted ? volumeOff : (volume == 0) ? volumeMuted : (volume < 50) ? volumeIcons[0] : volumeIcons[1];
    }
    Text {
        id: soundText
        anchors.centerIn: parent
        text: `${parent.getSound()}% ${parent.getIcon()}`
        color: Colors.on_background
    }
    PwObjectTracker {
        id: tracker
        objects: [Pipewire.defaultAudioSink]
    }
}
