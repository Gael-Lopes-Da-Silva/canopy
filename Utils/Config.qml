pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.Utils

Singleton {
    id: config

    readonly property var all: JSON.parse(config_fileviw.text())
    readonly property var wallpaper: all.wallpaper ?? null

    FileView {
        id: config_fileviw

        readonly property string defaultSource: Paths.join(Paths.base, "shell.json")

        path: Qt.resolvedUrl(defaultSource)
        blockLoading: true
        watchChanges: true

        onFileChanged: {
            console.info("Configuration reloaded !");
            reload();
        }
    }
}
