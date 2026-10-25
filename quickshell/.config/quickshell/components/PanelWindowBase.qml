import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../theme"

PanelWindow {
    id: win

    property bool active: false
    property string title: ""

    Theme {
        id: theme
    }

    // Settable size properties with defaults from Theme
    property int panelWidth: theme.panelWidth
    property int panelHeight: theme.panelHeight

    implicitWidth: panelWidth
    implicitHeight: panelHeight

    default property alias content: innerLayout.data

    color: "transparent"

    // Preserve keyboard focus behavior using Wayland layer-shell.
    WlrLayershell.keyboardFocus: win.active
        ? WlrKeyboardFocus.Exclusive
        : WlrKeyboardFocus.None

    Rectangle {
        anchors.fill: parent
        color: theme.bgBase
        radius: theme.radiusMain
        border.color: theme.borderColor
        border.width: 1

        ColumnLayout {
            id: innerLayout

            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: win.title
                color: theme.textPrimary
                font.pixelSize: 18
                font.bold: true
                visible: win.title !== ""
            }
        }
    }
}
