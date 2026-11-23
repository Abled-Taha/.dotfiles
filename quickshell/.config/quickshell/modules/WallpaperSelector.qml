
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../components"
import "../theme"

Scope {
    id: root

    property bool active: false
    property string filterText: ""
    property var wallpapers: []
    property var filteredWallpapers: []

    Theme {
        id: theme
    }

    function prepareWallpapers(paths) {
        return paths.map(path => ({
            path: path,
            filename: path.substring(path.lastIndexOf("/") + 1).toLowerCase()
        }));
    }

    function updateFilter() {
        if (!filterText) {
            filteredWallpapers = wallpapers;
            return;
        }

        var query = filterText;

        filteredWallpapers = wallpapers.filter(item =>
            item.filename.includes(query)
        );
    }

    function selectWallpaper(wallpaper) {
        if (!wallpaper || !wallpaper.path || applyWallpaper.running)
            return;

        applyWallpaper.command = [
            "bash",
            "-c",
            `
                path="$1"
                escaped=$(printf '%s' "$path" | sed 's/[\\\\&|]/\\\\&/g')

                sed -i -E \
                  "s|/home/[^/]*/\\\\.dotfiles/wallpapers/[^\\\"']*|$escaped|g" \
                  "$HOME/.dotfiles/quickshell/.config/quickshell/services/Wallpaper.qml"
            `,
            "wallpaper-selector",
            wallpaper.path
        ];

        applyWallpaper.running = true;
    }

    IpcHandler {
        target: "wallpaper"

        function toggle() {
            root.active = !root.active;
        }

        function open() {
            root.active = true;
        }

        function close() {
            root.active = false;
        }
    }

    Process {
        id: scanner

        command: [
            "bash",
            "-c",
            "find \"$HOME/.dotfiles/wallpapers\" -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.avif' -o -iname '*.bmp' \\) -print 2>/dev/null"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                root.wallpapers = root.prepareWallpapers(
                    text.split("\n").filter(path => path.length > 0)
                );

                root.updateFilter();
            }
        }
    }

    Process {
        id: applyWallpaper

        stderr: StdioCollector {}

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                console.info("Wallpaper configuration updated.");
                root.active = false;
            } else {
                console.warn("Wallpaper update failed:", exitCode);
            }
        }
    }

    Component.onCompleted: {
        scanner.running = true;
    }

    Variants {
        model: Quickshell.screens

        delegate: PanelWindowBase {
            id: panel

            required property var modelData

            screen: modelData

            visible: root.active
            active: root.active

            title: "Wallpapers"

            // Navigation belongs here because wallpaperGrid
            // is declared inside this PanelWindowBase.

            function moveSelection(direction) {
                var columns = Math.max(
                    1,
                    Math.floor(wallpaperGrid.width / wallpaperGrid.cellWidth)
                );

                var index = wallpaperGrid.currentIndex;
                var count = wallpaperGrid.count;

                if (count <= 0)
                    return;

                if (index < 0)
                    index = 0;

                switch (direction) {
                case "left":
                    if (index > 0 && index % columns !== 0)
                        index--;
                    break;

                case "right":
                    if (index + 1 < count && index % columns !== columns - 1)
                        index++;
                    break;

                case "up":
                    if (index - columns >= 0)
                        index -= columns;
                    break;

                case "down":
                    if (index + columns < count)
                        index += columns;
                    break;
                }

                wallpaperGrid.currentIndex = index;
                wallpaperGrid.positionViewAtIndex(
                    index,
                    GridView.Contain
                );
            }

            onVisibleChanged: {
                if (visible) {
                    searchField.text = "";
                    searchField.forceActiveFocus();
                    wallpaperGrid.currentIndex = 0;
                }
            }

            SearchInput {
                id: searchField

                Layout.fillWidth: true
                placeholderText: "Search wallpapers..."

                onTextChanged: {
                    root.filterText = text.toLowerCase();
                    root.updateFilter();
                    wallpaperGrid.currentIndex = 0;
                }

                Keys.onLeftPressed: panel.moveSelection("left")
                Keys.onRightPressed: panel.moveSelection("right")
                Keys.onUpPressed: panel.moveSelection("up")
                Keys.onDownPressed: panel.moveSelection("down")

                Keys.onEscapePressed: root.active = false

                onAccepted: {
                    var model = wallpaperGrid.model;

                    if (model &&
                        model.length > 0 &&
                        wallpaperGrid.currentIndex >= 0 &&
                        wallpaperGrid.currentIndex < model.length) {
                        root.selectWallpaper(
                            model[wallpaperGrid.currentIndex]
                        );
                    }
                }
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                GridView {
                    id: wallpaperGrid

                    width: parent.width

		    cellWidth: Math.floor(width / 5)
                    cellHeight: 120

                    focus: false
                    clip: true

                    model: root.filteredWallpapers

                    delegate: Rectangle {
                        required property var modelData
                        required property int index

			width: wallpaperGrid.cellWidth - 12
                        height: 108

                        radius: theme.radiusItem

                        color: wallpaperGrid.currentIndex === index
                            ? theme.bgSurfaceSelected
                            : theme.bgSurface

                        border.width: 1

                        border.color: wallpaperGrid.currentIndex === index
                            ? theme.borderAccent
                            : theme.borderColor

                        Image {
                            anchors.fill: parent
                            anchors.margins: 4

                            source: "file://" + modelData.path

                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            cache: true
                            smooth: true
                            sourceSize: Qt.size(276, 208)
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: {
                                wallpaperGrid.currentIndex = index;
                            }

                            onClicked: {
                                root.selectWallpaper(modelData);
                            }
                        }
                    }
                }
            }
        }
    }
}

