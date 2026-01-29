import QtQuick
import Quickshell
import Quickshell.Io

import qs.services

Scope {
    IpcHandler {
        target: "sidebar"

        function toggle() {
            States.showSidebar = !States.showSidebar;
        }

        function show() {
            States.showSidebar = true;
        }

        function hide() {
            States.showSidebar = false;
        }
    }

    IpcHandler {
        target: "wrapper"

        function toggle() {
            States.showWrapper = !States.showWrapper;
        }

        function show() {
            States.showWrapper = true;
        }

        function hide() {
            States.showWrapper = false;
        }
    }
}
