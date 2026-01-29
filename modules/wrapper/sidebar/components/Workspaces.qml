import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.configs
import qs.components
import qs.services
import qs.services.ipc

Loader {
    required property var screen

    id: root
    active: true
    visible: true
    sourceComponent: ColumnLayout {
        spacing: Config.appearance.sidebar.workspaces.spacing

        Rectangle {
            radius: Config.appearance.sidebar.workspaces.windowCount.radius
            color: Config.appearance.sidebar.workspaces.windowCount.background

            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: Config.appearance.sidebar.workspaces.windowCount.size
            Layout.preferredWidth: Config.appearance.sidebar.workspaces.windowCount.size

            Icon {
                visible: Ipc.compositor.monitor?.workspace?.surfaceCount <= 0
                icon: Globals.icons.layout_3_fill
                color: Config.appearance.sidebar.workspaces.windowCount.color
                size: Config.appearance.sidebar.workspaces.windowCount.iconSize

                anchors {
                    centerIn: parent
                    alignWhenCentered: false
                }
            }

            Text {
                visible: Ipc.compositor.monitor?.workspace?.surfaceCount > 0
                text: Ipc.compositor.monitor?.workspace?.surfaceCount ?? ""
                color: Config.appearance.sidebar.workspaces.windowCount.color
                font.pointSize: Config.appearance.sidebar.workspaces.windowCount.fontSize

                anchors {
                    centerIn: parent
                    alignWhenCentered: false
                }
            }
        }

        Rectangle {
            radius: Config.appearance.sidebar.workspaces.indicators.radius
            color: Config.appearance.sidebar.workspaces.indicators.background

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: Config.appearance.sidebar.workspaces.indicators.size
            Layout.preferredHeight: (Config.appearance.sidebar.workspaces.indicators.size * (Ipc.compositor.monitor?.workspaceCount ?? 1)) + (Config.appearance.sidebar.workspaces.indicators.spacing * ((Ipc.compositor.monitor?.workspaceCount ?? 1) - 1))

            ColumnLayout {
                spacing: Config.appearance.sidebar.workspaces.indicators.spacing

                anchors {
                    centerIn: parent
                }

                Repeater {
                    model: Ipc.compositor.monitor?.workspaces

                    Item {
                        Layout.alignment: Qt.AlignCenter
                        Layout.preferredWidth: Config.appearance.sidebar.workspaces.indicators.size
                        Layout.preferredHeight: Config.appearance.sidebar.workspaces.indicators.size

                        Rectangle {
                            color: {
                                if ((modelData.workspaceId <= 0 || modelData.workspaceId > 10) && modelData.surfaces.length > 0) {
                                    return Config.appearance.sidebar.workspaces.indicators.indicator.specialSelected;
                                } else if (modelData.active) {
                                    return Config.appearance.sidebar.workspaces.indicators.indicator.selected;
                                } else {
                                    return Config.appearance.sidebar.workspaces.indicators.indicator.background;
                                }
                            }
                            radius: Config.appearance.sidebar.workspaces.indicators.radius

                            anchors {
                                fill: parent
                                margins: Config.appearance.sidebar.workspaces.indicators.indicator.margin
                            }

                            Loader {
                                active: !modelData.special
                                visible: !modelData.special
                                sourceComponent: Text {
                                    visible: !modelData.special
                                    text: modelData.name
                                    color: Config.appearance.sidebar.workspaces.indicators.indicator.color
                                    font.pointSize: Config.appearance.sidebar.workspaces.indicators.indicator.fontSize
                                }

                                anchors {
                                    centerIn: parent
                                    alignWhenCentered: false
                                }
                            }

                            Loader {
                                active: modelData.special
                                visible: modelData.special
                                sourceComponent: Icon {
                                    icon: Globals.icons.asterisk_fill
                                    color: Config.appearance.sidebar.workspaces.indicators.indicator.specialColor
                                    font.pointSize: Config.appearance.sidebar.workspaces.indicators.indicator.specialFontSize
                                }

                                anchors {
                                    centerIn: parent
                                    alignWhenCentered: false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

