import QtQuick
import QtQuick.Controls
import "../theme"

TextField {
    id: root

    Theme { id: theme }

    placeholderText: "Search..."
    placeholderTextColor: theme.textMuted
    color: theme.textPrimary
    font.pixelSize: 13
    font.family: theme.fontMono
    padding: 8

    background: Rectangle {
        color: theme.bgSurface
        radius: theme.radiusItem
        border.color: root.activeFocus ? theme.borderAccent : theme.borderColor
        border.width: 1
    }
}
