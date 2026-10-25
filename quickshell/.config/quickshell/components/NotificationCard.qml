import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: root

    property var notification
    signal dismissed()

    Theme { id: theme }

    implicitWidth: 360
    implicitHeight: layout.implicitHeight + 24

    color: theme.bgSurface
    radius: theme.radiusItem
    border.color: theme.borderColor
    border.width: 1

    ColumnLayout {
        id: layout
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 12
        }
        spacing: 6

        // Header
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: (root.notification && root.notification.appName) ? root.notification.appName : "System"
                color: theme.textMuted
                font.pixelSize: 11
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Rectangle {
                width: 18
                height: 18
                radius: 9
                color: closeArea.containsMouse ? theme.bgSurfaceSelected : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    color: theme.textMuted
                    font.pixelSize: 10
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.dismissed()
                }
            }
        }

        // Title / Summary
        Text {
            text: (root.notification && root.notification.summary) ? root.notification.summary : ""
            color: theme.textPrimary
            font.bold: true
            font.pixelSize: 13
            elide: Text.ElideRight
            Layout.fillWidth: true
            visible: text !== ""
        }

        // Body Message
        Text {
            text: (root.notification && root.notification.body) ? root.notification.body : ""
            color: theme.textPrimary
            font.pixelSize: 12
            wrapMode: Text.Wrap
            maximumLineCount: 4
            Layout.fillWidth: true
            visible: text !== ""
        }
    }
}
