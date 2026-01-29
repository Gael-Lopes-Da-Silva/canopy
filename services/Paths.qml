pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    readonly property string root: join(Quickshell.shellDir, "")
    readonly property string home: join(Quickshell.env("HOME"), "")
    readonly property string scripts: join(root, "scripts/")
    readonly property string assets: join(root, "assets/")
    readonly property string wallpapers: join(assets, "wallpapers/")
    readonly property string fonts: join(assets, "fonts/")

    function join(base: string, sub: string): string {
        return base.endsWith("/") ? base + sub : base + "/" + sub;
    }

    function resolve(path: string): string {
        if (!path)
            return "";

        if (path.startsWith("~/")) {
            return Paths.join(Paths.home, path);
        }

        if (path.startsWith("./")) {
            return Paths.join(Paths.root, path);
        }

        return path;
    }
}
