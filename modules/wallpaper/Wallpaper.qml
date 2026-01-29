pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.configs
import qs.services

Loader {
    active: true
    visible: true
    sourceComponent: Component {
        Variants {
            model: Quickshell.screens
            delegate: PanelWindow {
                id: wallpaper

                required property var modelData

                property string notFoundPath: Paths.join(Paths.wallpapers, "wallpaper_not_found")
                property string defaultPath: Paths.join(Paths.wallpapers, "wallpaper_default")
                property string customPath: Config.general?.wallpaper?.path ?? ""

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

                Loader {
                    id: wallpaperLoader
                    active: true
                    visible: true
                    sourceComponent: true ? wallpaperImage : wallpaperAnimatedImage

                    anchors {
                        fill: parent
                    }
                }

                Component {
                    id: wallpaperImage

                    Image {
                        asynchronous: true
                        source: Qt.resolvedUrl(wallpaper.customPath ? Paths.resolve(wallpaper.customPath) : wallpaper.defaultPath)
                        fillMode: Image.PreserveAspectCrop

                        onStatusChanged: {
                            if (status === Image.Error && source !== wallpaper.notFoundPath) {
                                source = Qt.resolvedUrl(wallpaper.notFoundPath);
                            }
                        }
                    }
                }

                Component {
                    id: wallpaperAnimatedImage

                    AnimatedImage {
                        asynchronous: true
                        source: Qt.resolvedUrl(wallpaper.customPath ? Paths.resolve(wallpaper.customPath) : wallpaper.defaultPath)
                        fillMode: Image.PreserveAspectCrop
                        playing: true

                        onStatusChanged: {
                            if (status === AnimatedImage.Error && source !== wallpaper.notFoundPath) {
                                source = Qt.resolvedUrl(wallpaper.notFoundPath);
                            }
                        }
                    }
                }
            }
        }
    }
}
