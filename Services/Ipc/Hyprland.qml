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
//         return root.handleRequest("j/monitors", data => {
//             Ipc.compositor.monitors = reconcileList(
//                 Ipc.compositor.monitors,
//                 data.map(m => ({
//                     monitorId: m.id.toString(),
//                     name: m.name,
//                     width: m.width,
//                     height: m.height,
//                     scale: m.scale,
//                     active: m.focused,
//                     activeWorkspaceId: m.activeWorkspace.id.toString()
//                 })),
//                 "monitorId",
//                 item => monitorFactory.createObject(null, item)
//             );
//             Ipc.compositor.monitor = Ipc.compositor.monitors.find(m => m.active) || null;
//             Ipc.compositor.monitorCount = Ipc.compositor.monitors.length;
//         });
//     }

//     function updateWorkspaces() {
//         return root.handleRequest("j/workspaces", data => {
//             Ipc.compositor.monitors.forEach(m => {
//                 m.workspaces = reconcileList(
//                     m.workspaces,
//                     data.filter(w => w.monitorID.toString() === m.monitorId).map(w => ({
//                         workspaceId: w.id.toString(),
//                         name: w.name,
//                         special: w.name === "special:magic",
//                         fullscreen: w.hasfullscreen,
//                         active: m.activeWorkspaceId === w.id.toString(),
//                         activeSurfaceId: w.lastwindow
//                     })),
//                     "workspaceId",
//                     item => workspaceFactory.createObject(null, item)
//                 ).sort((a, b) => a.workspaceId - b.workspaceId);
//                 m.workspace = m.workspaces.find(w => w.active) || null;
//                 m.workspaceCount = m.workspaces.length;
//             });
//         });
//     }

//     function updateSurfaces() {
//         return root.handleRequest("j/clients", data => {
//             Ipc.compositor.monitors.forEach(m =>
//                 m.workspaces.forEach(w => {
//                     w.surfaces = reconcileList(
//                         w.surfaces,
//                         data.filter(s => s.workspace.id.toString() === w.workspaceId).map(s => ({
//                             surfaceId: s.address,
//                             title: s.title,
//                             fullscreen: s.fullscreen === 1,
//                             active: w.activeSurfaceId === s.address
//                         })),
//                         "surfaceId",
//                         item => surfaceFactory.createObject(null, item)
//                     );
//                     w.surface = w.surfaces.find(s => s.active) || null;
//                     w.surfaceCount = w.surfaces.length;
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

//         signal eventReceived(string name, string data)

//         id: events
//         connected: false
//         path: Quickshell.env("XDG_RUNTIME_DIR") + "/hypr/" + Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") + "/.socket2.sock"
//         parser: SplitParser {
//             onRead: (line) => {
//                 if (!line || line.length === 0) return;

//                 const chuncks = line.split(">>");
//                 const name = chuncks.length > 0 ? chuncks[0] : "";
//                 const data = chuncks.length > 1 ? chuncks[1] : "";

//                 events.eventReceived(name, data);
//             }
//         }

//         onEventReceived: (name, data) => {
//             switch (name) {
//                 case "focusedmon": {
//                     enqueueUpdate(() => root.updateMonitors());
//                     break;
//                 }

//                 case "monitoradded": {
//                     enqueueUpdate(() => root.updateMonitors());
//                     break;
//                 }

//                 case "monitorremovedv2": {
//                     const [monitorId] = data.split(",");
//                     let index = Ipc.compositor.monitors.findIndex(m => m.monitorId === monitorId);
//                     if (index >= 0) {
//                         Ipc.compositor.monitors.splice(index, 1);
//                         Ipc.compositor.monitorCount = Ipc.compositor.monitors.length;
//                     }
//                     break;
//                 }

//                 case "workspace": {
//                     enqueueUpdate(() => root.updateMonitors().then(root.updateWorkspaces));
//                     break;
//                 }

//                 case "activespecial": {
//                     enqueueUpdate(() => root.updateMonitors().then(root.updateWorkspaces));
//                     break;
//                 }

//                 case "renameworkspace": {
//                     enqueueUpdate(() => root.updateWorkspaces());
//                     break;
//                 }

//                 case "openwindow": {
//                     enqueueUpdate(() => root.updateSurfaces());
//                     break;
//                 }

//                 case "closewindow": {
//                     const [surfaceId] = data.split(",");
//                     Ipc.compositor.monitors.forEach(m =>
//                         m.workspaces.forEach(w => {
//                             let index = w.surfaces.findIndex(s => s.surfaceId === `0x${surfaceId}`);
//                             if (index >= 0) {
//                                 w.surfaces.splice(index, 1);
//                                 w.surfaceCount = w.surfaces.length;
//                             }
//                         })
//                     );
//                     break;
//                 }

//                 case "activewindowv2": {
//                     const [surfaceId] = data.split(",");
//                     Ipc.compositor.monitors.forEach(m =>
//                         m.workspaces.forEach(w => {
//                             w.surfaces.forEach(s => {
//                                 if (s.surfaceId === `0x${surfaceId}`) {
//                                     s.urgent = false;
//                                     w.urgent = false;
//                                 }
//                                 s.active = s.surfaceId === `0x${surfaceId}`;
//                             });
//                             w.surface = w.surfaces.find(s => s.active) || null;
//                         })
//                     );
//                     break;
//                 }

//                 case "fullscreen": {
//                     const [fullscreen] = data.split(",");
//                     Ipc.compositor.monitor.workspace.fullscreen = fullscreen === "1";
//                     Ipc.compositor.monitor.workspace.surface.fullscreen = fullscreen === "1";
//                     break;
//                 }

//                 case "urgent": {
//                     const [surfaceId] = data.split(",");
//                     Ipc.compositor.monitors.forEach(m =>
//                         m.workspaces.forEach(w =>
//                             w.surfaces.forEach(s => {
//                                 if (s.surfaceId === `0x${surfaceId}`) {
//                                     s.urgent = true;
//                                     w.urgent = true;
//                                 }
//                             })
//                         )
//                     );
//                     break;
//                 }

//                 case "windowtitlev2": {
//                     const [surfaceId, surfaceName] = data.split(",");
//                     Ipc.compositor.monitors.forEach(m =>
//                         m.workspaces.forEach(w =>
//                             w.surfaces.forEach(s => {
//                                 if (s.surfaceId === `0x${surfaceId}`) {
//                                     s.title = surfaceName;
//                                 }
//                             })
//                         )
//                     );
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
//         path: Quickshell.env("XDG_RUNTIME_DIR") + "/hypr/" + Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") + "/.socket.sock"
//         parser: SplitParser {
//             splitMarker: ""
//             onRead: (data) => {
//                 requests.output += data;
//             }
//         }

//         onConnectedChanged: {
//             if (connected) {
//                 write(command);
//                 flush();
//                 return;
//             }

//             try {
//                 const data = JSON.parse(output);
//                 finished(command, data);
//                 output = "";
//             } catch (error) {}
//         }

//         function request(request) {
//             command = request;
//             connected = true;
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
