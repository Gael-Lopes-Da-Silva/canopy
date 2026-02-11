import QtQuick
import QtQuick.Shapes
import Quickshell

import qs.Utils

Item {
    id: framebar

    readonly property int size: 20

    required property var screen

    PanelWindow {
        color: "#1a1a1a"
        screen: screen
        aboveWindows: true
        implicitHeight: framebar.size

        anchors {
            top: true
            left: true
            right: true
        }
    }

    PanelWindow {
        color: "#1a1a1a"
        screen: screen
        aboveWindows: true
        implicitHeight: framebar.size

        anchors {
            left: true
            right: true
            bottom: true
        }
    }

    PanelWindow {
        color: "#1a1a1a"
        screen: screen
        aboveWindows: true
        implicitWidth: framebar.size

        anchors {
            top: true
            left: true
            bottom: true
        }
    }

    PanelWindow {
        color: "#1a1a1a"
        screen: screen
        aboveWindows: true
        implicitWidth: framebar.size

        anchors {
            top: true
            right: true
            bottom: true
        }
    }

    PanelWindow {
        color: "transparent"
        screen: screen
        exclusionMode: ExclusionMode.Ignore
        focusable: false
        aboveWindows: true
        mask: Region {}

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        Shape {
            antialiasing: true
            preferredRendererType: Shape.GeometryRenderer

            anchors {
                fill: parent
            }

            ShapePath {
                strokeWidth: 0
                strokeColor: "transparent"
                fillColor: "#1a1a1a"

                startX: framebar.size
                startY: framebar.size

                PathLine {
                    x: framebar.size
                    y: framebar.size * 2
                }

                PathArc {
                    x: framebar.size * 2
                    y: framebar.size
                    radiusX: framebar.size
                    radiusY: framebar.size
                }
            }

            ShapePath {
                strokeWidth: 0
                strokeColor: "transparent"
                fillColor: "#1a1a1a"

                startX: framebar.screen.width - framebar.size
                startY: framebar.size

                PathLine {
                    x: framebar.screen.width - framebar.size * 2
                    y: framebar.size
                }

                PathArc {
                    x: framebar.screen.width - framebar.size
                    y: framebar.size * 2
                    radiusX: framebar.size
                    radiusY: framebar.size
                }
            }

            ShapePath {
                strokeWidth: 0
                strokeColor: "transparent"
                fillColor: "#1a1a1a"

                startX: framebar.screen.width - framebar.size
                startY: framebar.screen.height - framebar.size

                PathLine {
                    x: framebar.screen.width - framebar.size
                    y: framebar.screen.height - framebar.size * 2
                }

                PathArc {
                    x: framebar.screen.width - framebar.size * 2
                    y: framebar.screen.height - framebar.size
                    radiusX: framebar.size
                    radiusY: framebar.size
                }
            }

            ShapePath {
                strokeWidth: 0
                strokeColor: "transparent"
                fillColor: "#1a1a1a"

                startX: framebar.size
                startY: framebar.screen.height - framebar.size

                PathLine {
                    x: framebar.size * 2
                    y: framebar.screen.height - framebar.size
                }

                PathArc {
                    x: framebar.size
                    y: framebar.screen.height - framebar.size * 2
                    radiusX: framebar.size
                    radiusY: framebar.size
                }
            }

            ShapePath {
                strokeWidth: 1
                strokeColor: "#2a2a2a"
                fillColor: "transparent"

                startX: framebar.size
                startY: framebar.size * 2

                PathArc {
                    x: framebar.size * 2
                    y: framebar.size
                    radiusX: framebar.size
                    radiusY: framebar.size
                }

                PathLine {
                    x: framebar.screen.width - framebar.size * 2
                    y: framebar.size
                }

                PathArc {
                    x: framebar.screen.width - framebar.size
                    y: framebar.size * 2
                    radiusX: framebar.size
                    radiusY: framebar.size
                }

                PathLine {
                    x: framebar.screen.width - framebar.size
                    y: framebar.screen.height - framebar.size * 2
                }

                PathArc {
                    x: framebar.screen.width - framebar.size * 2
                    y: framebar.screen.height - framebar.size
                    radiusX: framebar.size
                    radiusY: framebar.size
                }

                PathLine {
                    x: framebar.size * 2
                    y: framebar.screen.height - framebar.size
                }

                PathArc {
                    x: framebar.size
                    y: framebar.screen.height - framebar.size * 2
                    radiusX: framebar.size
                    radiusY: framebar.size
                }

                PathLine {
                    x: framebar.size
                    y: framebar.size * 2
                }
            }
        }
    }
}
