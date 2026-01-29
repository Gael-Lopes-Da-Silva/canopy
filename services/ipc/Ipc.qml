pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import qs.configs
import qs.components.ipc

Singleton {
    id: root

    property var compositor: Compositor {}

    signal ipcLoaded()

    Process {
        command: ["sh", "-c", "ps -e | grep -E 'hyprland|niri' | awk '{print $NF}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                let result = this.text.trim()
                if (!result) {
                    ipcLoaded()
                    return
                }

                compositor.name = result

                let supported = ["hyprland", "niri"]
                if (supported.includes(result)) {
                    compositor.supported = true
                }
                ipcLoaded()
            }
        }
    }

    onIpcLoaded: {
        switch (compositor.name) {
            case "hyprland": {
                Hyprland.initialize()
                break
            }

            case "niri": {
                Niri.initialize()
                break
            }
        }
    }
}

