pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property AppearanceProperty padding: AppearanceProperty {
        icon: 5
        little: 10
        medium: 15
        large: 25
    }
    readonly property AppearanceProperty margin: AppearanceProperty {
        icon: 5
        little: 10
        medium: 15
        large: 25
    }
    readonly property AppearanceProperty radius: AppearanceProperty {
        icon: 10
        little: 20
        medium: 30
        large: 40
    }
    readonly property AppearanceProperty width: AppearanceProperty {
        icon: 40
        little: 80
        medium: 200
        large: 300
        xl: 400
        xxl: 500
    }
    readonly property AppearanceProperty height: AppearanceProperty {
        icon: 40
        little: 80
        medium: 200
        large: 300
        xl: 400
        xxl: 500
    }
    readonly property AppearanceProperty fontSize: AppearanceProperty {
        icon: 10
        little: 20
        medium: 30
        large: 40
    }
    readonly property AppearanceProperty duration: AppearanceProperty {
        icon: 150
        little: 250
        medium: 450
        large: 450
    }

    component AppearanceProperty: QtObject {
        required property int icon
        required property int little
        required property int medium
        required property int large
        property int xl: 0
        property int xxl: 0
    }
}
