import QtQuick
import Quickshell

import qs.Utils

PanelWindow {
    id: background_window

    required property var modelData

    color: Config.themes?.wallpaper?.background ?? "#111111"
    visible: Config.options?.wallpaper?.enable ?? true
    focusable: false
    aboveWindows: false
    exclusionMode: ExclusionMode.Ignore
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    Image {
        id: background_image

        readonly property string customSource: Config.wallpaper?.path ?? ""
        readonly property string defaultSource: Paths.join(Paths.wallpapers, "canopy1")
        readonly property string fallbackSource: Paths.join(Paths.wallpapers, "not_found")

        property string currentSource

        source: Qt.resolvedUrl(currentSource)
        asynchronous: Config.options?.wallpaper?.asynchronous ?? true
        cache: Config.options?.wallpaper?.cache ?? true
        autoTransform: Config.options?.wallpaper?.auto_transform ?? true
        mirror: Config.options?.wallpaper?.horizontal_mirror ?? false
        mirrorVertically: Config.options?.wallpaper?.vertical_mirror ?? false
        smooth: Config.options?.wallpaper?.smooth ?? true
        mipmap: Config.options?.wallpaper?.mipmap ?? false
        fillMode: {
            if (!Config.options?.wallpaper?.fill_mode) {
                return Image.PreserveAspectFit;
            }

            switch (Config.options?.wallpaper?.fill_mode) {
            case "Stretch":
                return Image.Stretch;
            case "PreserveAspectFit":
                return Image.PreserveAspectFit;
            case "PreserveAspectCrop":
                return Image.PreserveAspectCrop;
            case "Tile":
                return Image.Tile;
            case "TileVertically":
                return Image.TileVertically;
            case "TileHorizontally":
                return Image.TileHorizontally;
            case "Pad":
                return Image.Pad;
            default:
                console.warn("Wallpaper: Invalid fill mode, defaulting to PreserveAspectFit !");
                return Image.PreserveAspectFit;
            }
        }

        anchors {
            fill: parent
        }

        onStatusChanged: {
            if (status === Image.Error) {
                currentSource = fallbackSource;
            }
        }

        onCustomSourceChanged: updateSource()

        Component.onCompleted: updateSource()

        function updateSource() {
            currentSource = customSource !== "" ? resolvePath(customSource) : defaultSource;
        }

        function resolvePath(path: string): string {
            if (path.startsWith("./")) {
                return Paths.join(Paths.base, path.replace("./", ""));
            }

            if (path.startsWith("~/")) {
                return Paths.join(Paths.home, path.replace("~/", ""));
            }

            return path;
        }
    }
}
