pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland

import qs.Services

Variants {
    model: Quickshell.screens
    delegate: PanelWindow {
        id: osd

        required property var modelData

        screen: modelData
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        anchors.bottom: true
        anchors.right: true

        width: 300
        height: 50

        WlrLayershell.namespace: Globals.namespace + "_osd"
        WlrLayershell.layer: WlrLayer.Top

        Rectangle {
            color: "#1a1a1a"
            anchors.fill: parent
            anchors.bottomMargin: -1
            anchors.rightMargin: -1
            topLeftRadius: 15
            border.width: 1
            border.color: "#3a3a3a"
        }
    }
}
