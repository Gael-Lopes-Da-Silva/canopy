// pragma Singleton
// pragma ComponentBehavior: Bound

// import QtQuick
// import Quickshell
// import Quickshell.Io

// import qs.services
// import qs.components.ipc

// Singleton {
//     id: root

//     function initialize() {
//         updateMonitors().then(updateWorkspaces).then(updateSurfaces);

//         events.connected = true;
//     }

//     function updateMonitors() {
//         return root.handleRequest("Outputs", data => {
//             Ipc.compositor.monitors = reconcileList(
//                 Ipc.compositor.monitors,
//                 Object.entries(data.Outputs).map(([name, m]) => ({
//                     monitorId: name,
//                     name: name,
//                     width: m.logical.width,
//                     height: m.logical.height,
//                     scale: m.logical.scale
//                 })),
//                 "monitorId",
//                 item => monitorFactory.createObject(null, item)
//             );
//         }).then(() => {
//             return root.handleRequest("FocusedOutput", data => {
//                 Ipc.compositor.monitors.forEach(m => {
//                     m.active = m.monitorId === data.FocusedOutput.name;
//                 });

//                 Ipc.compositor.monitor = Ipc.compositor.monitors.find(m => m.active) || null;
//                 Ipc.compositor.monitorCount = Ipc.compositor.monitors.length;
//                 Ipc.compositor.activeMonitorId = Ipc.compositor.monitor?.monitorId || ""
//             });
//         });
//     }

//     function updateWorkspaces() {
//         return root.handleRequest("Workspaces", data => {
//             Ipc.compositor.monitors.forEach(m => {
//                 m.workspaces = reconcileList(
//                     m.workspaces,
//                     data.Workspaces.filter(w => w.output === m.monitorId).map(w => ({
//                         workspaceId: w.id.toString(),
//                         name: w.idx.toString(),
//                         urgent: w.is_urgent,
//                         special: w.name === "special:magic",
//                         active: w.is_active,
//                         activeSurfaceId: w.active_window_id
//                     })),
//                     "workspaceId",
//                     item => workspaceFactory.createObject(null, item)
//                 ).sort((a, b) => a.workspaceId - b.workspaceId);
//                 m.workspace = m.workspaces.find(w => w.active) || null;
//                 m.workspaceCount = m.workspaces.length;
//                 m.activeWorkspaceId = m.workspace?.workspaceId || "";
//             });
//         });
//     }

//     function updateSurfaces() {
//         return root.handleRequest("Windows", data => {
//             Ipc.compositor.monitors.forEach(m =>
//                 m.workspaces.forEach(w => {
//                     w.surfaces = reconcileList(
//                         w.surfaces,
//                         data.Windows.filter(s => s.workspace_id.toString() === w.workspaceId).map(s => ({
//                             surfaceId: s.id.toString(),
//                             title: s.title,
//                             active: s.is_focused
//                         })),
//                         "surfaceId",
//                         item => surfaceFactory.createObject(null, item)
//                     );
//                     w.surface = w.surfaces.find(s => s.active) || null;
//                     w.surfaceCount = w.surfaces.length;
//                     w.activeSurfaceId = w.surface?.surfaceId || "";
//                 })
//             );
//         });
//     }

//     function reconcileList(oldList, newItems, key, factory) {
//         const result = [];

//         newItems.forEach(item => {
//             const old = oldList.find(x => x[key] === item[key]);
//             if (old) {
//                 for (let k in item) {
//                     if (old[k] !== item[k]) {
//                         old[k] = item[k];
//                     }
//                 }
//                 result.push(old);
//                 return;
//             }

//             result.push(factory(item));
//         });

//         return result;
//     }

//     function handleRequest(request, fn) {
//         return new Promise(resolve => {
//             let handler = (command, data) => {
//                 if (command !== request) return;
//                 requests.finished.disconnect(handler);
//                 fn(data);
//                 resolve();
//             };

//             requests.request(request);
//             requests.finished.connect(handler);
//         });
//     }

//     Socket {
//         property var updateQueue: Promise.resolve()

//         signal eventReceived(string name, var data)

//         id: events
//         connected: false
//         path: Quickshell.env("NIRI_SOCKET")
//         parser: SplitParser {
//             onRead: (response) => {
//                 try {
//                     const result = JSON.parse(response)
//                     const [[name, data]] = Object.entries(result);
//                     events.eventReceived(name, data);
//                 } catch (error) {}
//             }
//         }

//         onConnectedChanged: {
//             if (connected) {
//                 write(`"EventStream"\n`);
//                 flush();
//                 return;
//             }
//         }

//         onEventReceived: (name, data) => {
//             switch (name) {
//                 case "WorkspaceActivated": {
//                     enqueueUpdate(() => root.updateMonitors().then(root.updateWorkspaces));
//                     break;
//                 }
//             }
//         }

//         function enqueueUpdate(fn) {
//             updateQueue = updateQueue.then(fn).catch(error => console.error(error));
//         }
//     }

//     Socket {
//         property string command: ""
//         property string output: ""

//         signal finished(string command, var result)

//         id: requests
//         connected: false
//         path: Quickshell.env("NIRI_SOCKET")
//         parser: SplitParser {
//             onRead: (data) => {
//                 requests.output += data;

//                 try {
//                     const result = JSON.parse(requests.output).Ok;
//                     requests.finished(requests.command, result);
//                     requests.output = "";
//                 } catch (error) {}
//             }
//         }

//         function request(request) {
//             command = request;
//             connected = true;

//             write(`"${command}"\n`);
//             flush();
//         }
//     }

//     Component {
//         id: monitorFactory

//         Monitor {}
//     }

//     Component {
//         id: workspaceFactory

//         Workspace {}
//     }

//     Component {
//         id: surfaceFactory

//         Surface {}
//     }
// }
