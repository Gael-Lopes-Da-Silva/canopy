import QtQuick
import Quickshell

import qs.Utils

PanelWindow {
    id: background

    required property var modelData

    color: "#111111"
    focusable: false
    aboveWindows: false
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    Image {
        id: background_image

        readonly property string customSource: Config.wallpaper?.path ?? ""
        readonly property string defaultSource: Paths.join(Paths.wallpapers, "default")
        readonly property string fallbackSource: Paths.join(Paths.wallpapers, "not_found")

        property string currentSource

        asynchronous: true
        autoTransform: true
        cache: true
        mirror: false
        mirrorVertically: false
        smooth: true
        mipmap: false
        fillMode: Image.PreserveAspectFit
        source: Qt.resolvedUrl(currentSource)

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
