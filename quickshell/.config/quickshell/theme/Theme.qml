import QtQuick

QtObject {
    // Colors
    readonly property color bgBase: "#181825"
    readonly property color bgSurface: "#1e1e2e"
    readonly property color bgSurfaceSelected: "#2d2f45"
    readonly property color borderColor: "#313244"
    readonly property color borderAccent: "#89b4fa"

    readonly property color textPrimary: "#cdd6f4"
    readonly property color textSecondary: "#a6adc8"
    readonly property color textMuted: "#6c7086"
    readonly property color textAccent: "#89b4fa"
    readonly property color textSuccess: "#a6e3a1"

    // Fonts
    readonly property string fontMono: "JetBrains Mono"

    // Sizes & Radius
    readonly property int panelWidth: 700
    readonly property int panelHeight: 500
    readonly property int radiusMain: 12
    readonly property int radiusItem: 6
}
