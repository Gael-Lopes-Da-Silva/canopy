import QtQuick
import Quickshell

import qs.Panels

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Component {
            Background {}
        }
    }
}
