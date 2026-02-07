pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.Services

Variants {
    model: Quickshell.screens
    delegate: PanelWindow {
        id: wallpaper

        required property var modelData

        property string notFoundPath: Paths.join(Paths.wallpapers, "wallpaper_not_found")
        property string customPath: Configs.general?.wallpaper ?? ""

        screen: modelData
        color: "transparent"
        focusable: false
        exclusionMode: ExclusionMode.Ignore
        anchors.bottom: true
        anchors.left: true
        anchors.right: true
        anchors.top: true

        WlrLayershell.namespace: Globals.namespace + "_wallpaper"
        WlrLayershell.layer: WlrLayer.Background

        Image {
            asynchronous: true
            source: Qt.resolvedUrl(wallpaper.customPath ? Paths.resolve(wallpaper.customPath) : wallpaper.notFoundPath)
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
