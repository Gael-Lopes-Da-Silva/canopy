pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import qs.Services

Singleton {
    readonly property string namespace: "canopy"

    readonly property var icons: JSON.parse(iconsData.text())
    readonly property var iconsFont: FontLoader {
        source: Paths.join(Paths.fonts, "MingCute.ttf")
    }

    FileView {
        id: iconsData
        path: Paths.join(Paths.fonts, "MingCute.json")
        watchChanges: true
        blockLoading: true

        onFileChanged: reload()
    }
}
