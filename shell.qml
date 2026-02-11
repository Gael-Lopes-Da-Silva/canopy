import QtQuick
import Quickshell

import qs.Panels

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Component {
            Item {
                required property var modelData

                Background {
                    screen: modelData
                }

                FrameBar {
                    screen: modelData
                }
            }
        }
    }
}
