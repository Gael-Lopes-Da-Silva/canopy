pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.services

Variants {
    model: Quickshell.screens
    delegate: PanelWindow {
        id: wallpaper

        required property var modelData

        property string notFoundPath: Paths.join(Paths.wallpapers, "wallpaper_not_found")
        property string defaultPath: Paths.join(Paths.wallpapers, "wallpaper_default")
        property string customPath: Configs.general?.wallpaper ?? ""

        screen: modelData
        color: "transparent"

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        WlrLayershell.namespace: Globals.namespace + "_wallpaper"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background

        Image {
            asynchronous: true
            source: Qt.resolvedUrl(wallpaper.customPath ? Paths.resolve(wallpaper.customPath) : wallpaper.defaultPath)
            fillMode: Image.PreserveAspectCrop

            anchors {
                fill: parent
            }

            onStatusChanged: {
                if (status === Image.Error && source !== wallpaper.notFoundPath) {
                    source = Qt.resolvedUrl(wallpaper.notFoundPath);
                }
            }
        }
    }
}
