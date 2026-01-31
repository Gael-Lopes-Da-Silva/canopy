pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import qs.services

Singleton {
    readonly property string namespace: "canopy"

    readonly property var config: JSON.parse(configData.text())

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

    FileView {
        id: configData
        path: Paths.join(Paths.root, "shell.json")
        watchChanges: true
        blockLoading: true

        onFileChanged: reload()
    }
}
