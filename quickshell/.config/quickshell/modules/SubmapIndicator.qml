import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../components"
import "../theme"

Scope {
    id: submapScope

    required property var submapServer

    Theme { id: theme }

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: submapWindow

            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
            }

            margins {
                top: 12
                left: 12
            }

            WlrLayershell.layer: WlrLayer.Overlay

            // Explicitly match window bounds to the content size so it doesn't draw a giant box
            implicitWidth: card.implicitWidth
            implicitHeight: card.implicitHeight
            color: "transparent"

            visible: submapScope.submapServer && submapScope.submapServer.currentSubmap !== ""

            Rectangle {
                id: card
                // Let the width fit the content row cleanly with padding
                implicitWidth: contentRow.implicitWidth + 28
                implicitHeight: 32

                color: theme.bgSurface
                radius: theme.radiusItem
                border.color: theme.accent ? theme.accent : "#ff0055"
                border.width: 1.5

                RowLayout {
                    id: contentRow
                    anchors {
                        fill: parent
                        leftMargin: 12
                        rightMargin: 12
                    }
                    spacing: 8

                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: theme.accent ? theme.accent : "#ff0055"
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        text: "SUBMAP: " + (submapScope.submapServer ? submapScope.submapServer.currentSubmap.toUpperCase() : "")
                        color: theme.textPrimary
                        font.pixelSize: 11
                        font.bold: true
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
