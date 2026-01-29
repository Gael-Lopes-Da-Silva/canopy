import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

import qs.configs
import qs.services
import qs.services.ipc
import qs.modules.wrapper.sidebar

Loader {
    id: root
    active: States.showWrapper && !Ipc.compositor.monitor?.workspace?.fullscreen
    visible: States.showWrapper && !Ipc.compositor.monitor?.workspace?.fullscreen
    sourceComponent: Variants {
        model: Quickshell.screens

        Item {
            required property var modelData

            id: wrapper

            PanelWindow {
                screen: wrapper.modelData
                color: "transparent"
                mask: Region {
                    item: mask
                    intersection: Intersection.Subtract

                    Region {
                        item: States.showSidebar ? sidebar : null
                        intersection: Intersection.Xor
                    }
                }

                WlrLayershell.namespace: Globals.appId + "_wrapper"
                WlrLayershell.exclusionMode: ExclusionMode.Ignore

                anchors {
                    top: true
                    left: true
                    right: true
                    bottom: true
                }

                Item {
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: Config.appearance.wrapper.shadow.enabled
                        shadowOpacity: Config.appearance.wrapper.shadow.opacity
                        shadowColor: Config.appearance.wrapper.shadow.color
                        shadowBlur: Config.appearance.wrapper.shadow.blur
                    }

                    anchors {
                        fill: parent
                    }

                    Rectangle {
                        color: Config.appearance.wrapper.background
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            maskSource: mask
                            maskEnabled: true
                            maskInverted: true
                        }

                        anchors {
                            fill: parent
                        }
                    }
                }

                Item {
                    id: mask
                    visible: false
                    layer.enabled: true

                    anchors {
                        fill: parent
                    }

                    Rectangle {
                        radius: Config.appearance.wrapper.radius

                        anchors {
                            fill: parent
                            margins: Config.appearance.wrapper.implicitSize
                            leftMargin: States.showSidebar
                                ? Config.appearance.sidebar.implicitSize
                                : Config.appearance.wrapper.implicitSize
                        }
                    }
                }

                Sidebar {
                    id: sidebar
                    screen: wrapper.modelData

                    anchors {
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                    }
                }

                Backgrounds {
                    screen: wrapper.modelData

                    anchors {
                        fill: parent
                    }
                }
            }

            Exclusions {
                screen: wrapper.modelData
            }
        }
    }
}

