pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: path

    readonly property string home: Quickshell.env("HOME")
    readonly property string base: Quickshell.shellDir
    readonly property string scripts: join(base, "Scripts")
    readonly property string assets: join(base, "Assets")
    readonly property string wallpapers: join(assets, "Wallpapers")
    readonly property string fonts: join(assets, "Fonts")

    function join(base: string, join: string): string {
        if (!join) {
            return base;
        }

        const baseClean = base.endsWith("/") ? base.slice(0, -1) : base;
        const joinClean = join.startsWith("/") ? join.slice(1) : join;

        return `${baseClean}/${joinClean}`;
    }
}
