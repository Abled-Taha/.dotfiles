import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../components"

Scope {
    id: popupsScope

    required property var notificationServer

    // Spawn a PanelWindow on every active screen
    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: popupWindow

            // Bind window to the specific screen instance
            required property var modelData
            screen: modelData

            anchors {
                top: true
                right: true
            }

            margins {
                top: 12
                right: 12
            }

            WlrLayershell.layer: WlrLayer.Overlay

            implicitWidth: 380
            implicitHeight: Math.min(popupList.contentHeight, 600)
            color: "transparent"

            visible: popupList.count > 0

            ListView {
                id: popupList
                anchors.fill: parent
                spacing: 10
                interactive: false

                model: popupsScope.notificationServer ? popupsScope.notificationServer.activeNotifications : []

                delegate: NotificationCard {
                    required property var modelData

                    width: popupList.width
                    notification: modelData

                    onDismissed: {
                        if (popupsScope.notificationServer) {
                            popupsScope.notificationServer.dismiss(modelData);
                        }
                    }
                }

                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 150 }
                    NumberAnimation { property: "scale"; from: 0.95; to: 1.0; duration: 150 }
                }
                remove: Transition {
                    NumberAnimation { property: "opacity"; to: 0; duration: 150 }
                }
                displaced: Transition {
                    NumberAnimation { properties: "y"; duration: 150 }
                }
            }
        }
    }
}
