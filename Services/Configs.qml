pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import qs.Services

Singleton {
    property var data: JSON.parse(configData.text())
    property var general: data?.general ?? []
    property var appearance: data?.appearance ?? []

    FileView {
        id: configData
        path: Paths.join(Paths.root, "shell.json")
        watchChanges: true
        blockLoading: true

        onFileChanged: reload()
    }
}
