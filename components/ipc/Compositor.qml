import QtQuick

QtObject {
    property string name: ""
    property bool supported: false
    property string activeMonitorId: ""
    property list<Monitor> monitors: []
    property Monitor monitor: null
    property int monitorCount: 0
}
