pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.Utils

Singleton {
    id: config

    readonly property var all: JSON.parse(config_fileview.text())

    readonly property var options: all.options ?? null
    readonly property var themes: all.themes ?? null

    FileView {
        id: config_fileview

        readonly property string defaultSource: Paths.join(Paths.base, "shell.json")

        path: Qt.resolvedUrl(defaultSource)
        blockLoading: true
        watchChanges: true

        onFileChanged: reload()
    }
}
