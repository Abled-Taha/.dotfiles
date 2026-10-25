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
    property var binds: []
    property string _jsonBuffer: ""
    property string filterText: ""

    Theme { id: theme }

    // IPC commands:
    // quickshell msg keybinds toggle
    // quickshell msg keybinds open
    // quickshell msg keybinds close
    IpcHandler {
        target: "keybinds"

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

    // Read MangoWM keybindings from the TOML configuration.
    Process {
        id: bindsProc

        command: [
            "bash",
            "-lc",
            "cat \"$HOME/.dotfiles/mango/.config/mango/modules/binds.toml\""
        ]

        running: false

        stdout: SplitParser {
            onRead: data => {
                root._jsonBuffer += data + "\n";
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.parseBindings(root._jsonBuffer);
            } else {
                console.warn(
                    "[Keybinds] Failed to read MangoWM bindings:",
                    exitCode
                );
                root.binds = [];
            }

            root._jsonBuffer = "";
        }
    }

    // Reload the keybinding list whenever the panel opens.
    onActiveChanged: {
        if (active) {
            _jsonBuffer = "";
            filterText = "";
            bindsProc.running = true;
        }
    }

    function parseBindings(configText) {
        var result = [];
        var section = "";
        var lines = configText.split(/\r?\n/);

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim();

            if (line === "" || line.startsWith("#"))
                continue;

            // Identify binding sections, e.g.:
            // [bind.default]
            // [bind.window.conflict]
            var sectionMatch = line.match(/^\[bind\.([^\]]+)\]$/);

            if (sectionMatch) {
                section = sectionMatch[1];
                continue;
            }

            // Ignore mouse bindings and unrelated TOML sections.
            if (!section)
                continue;

            // Match quoted TOML keys:
            // "super+slash" = "spawn_shell, quickshell msg keybinds toggle"
            // "none+r" = ["setkeymode, default", "reload_config"]
            var entryMatch = line.match(/^"((?:\\.|[^"\\])*)"\s*=\s*(.+)$/);

            if (!entryMatch)
                continue;

            var combo = entryMatch[1].trim();
            var rawValue = entryMatch[2].trim();
            var actions = [];

            // Parse either a single TOML string or an array of strings.
            if (rawValue.startsWith("[")) {
                var quotedStrings =
                    rawValue.match(/"(?:\\.|[^"\\])*"/g) || [];

                for (var j = 0; j < quotedStrings.length; j++) {
                    try {
                        actions.push(JSON.parse(quotedStrings[j]));
                    } catch (e) {
                        actions.push(
                            quotedStrings[j].slice(1, -1)
                        );
                    }
                }
            } else {
                try {
                    actions.push(JSON.parse(rawValue));
                } catch (e) {
                    actions.push(rawValue);
                }
            }

            if (actions.length === 0)
                continue;

            // Split the combination into modifiers and the actual key.
            var parts = combo.split("+");
            var key = parts.pop() || "";

            var modifiers = parts
                .filter(part => part.toLowerCase() !== "none")
                .map(part => part.toUpperCase());

            // Remove the suffix used by MangoWM's conflict sections
            // when displaying the mode name.
            var mode = section.replace(/\.conflict$/, "");

            result.push({
                key: key,
                modifiers: modifiers.join(" + "),
                combo: combo.toUpperCase().replace(/\+/g, " + "),
                dispatcher: actions[0],
                actions: actions,
                description: "",
                mode: mode,
                section: section
            });
        }

        root.binds = result;
    }

    function getKeyText(bind) {
        return bind.combo || bind.key.toUpperCase();
    }

    function getActionText(bind) {
        if (!bind || !bind.actions)
            return "";

        return bind.actions.join("  →  ");
    }

    Variants {
        model: Quickshell.screens

        delegate: PanelWindowBase {
            required property var modelData

            screen: modelData

            // Show the panel on the first available screen.
            visible: root.active
                && Quickshell.screens.length > 0
                && modelData.name === Quickshell.screens[0].name

            active: root.active
            title: "MangoWM Keybinds"

            onVisibleChanged: {
                if (visible)
                    searchField.forceActiveFocus();
            }

            SearchInput {
                id: searchField

                Layout.fillWidth: true
                placeholderText: "Search keybinds or descriptions..."

                onTextChanged: {
                    root.filterText = text.toLowerCase();
                    bindList.currentIndex = 0;
                }

                Keys.onDownPressed: bindList.incrementCurrentIndex()
                Keys.onUpPressed: bindList.decrementCurrentIndex()
                Keys.onEscapePressed: root.active = false
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ListView {
                    id: bindList

                    spacing: 6
                    focus: false

                    model: root.binds.filter(b => {
                        if (!root.filterText)
                            return true;

                        var combo = root.getKeyText(b).toLowerCase();
                        var action = root.getActionText(b).toLowerCase();
                        var mode = b.mode.toLowerCase();

                        return combo.includes(root.filterText)
                            || action.includes(root.filterText)
                            || mode.includes(root.filterText);
                    })

                    delegate: Rectangle {
                        required property var modelData
                        required property int index

                        width: ListView.view.width
                        height: 48

                        color: bindList.currentIndex === index
                            ? theme.bgSurfaceSelected
                            : theme.bgSurface

                        radius: theme.radiusItem

                        border.color: bindList.currentIndex === index
                            ? theme.borderAccent
                            : theme.borderColor

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 12

                            ColumnLayout {
                                Layout.preferredWidth: 180
                                Layout.maximumWidth: 220
                                spacing: 2

                                Text {
                                    text: root.getKeyText(modelData)

                                    color: theme.textAccent
                                    font.bold: true
                                    font.family: theme.fontMono
                                    font.pixelSize: 12
                                    elide: Text.ElideRight

                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: modelData.mode || "default"

                                    color: theme.textMuted
                                    font.pixelSize: 10
                                    elide: Text.ElideRight

                                    Layout.fillWidth: true
                                }
                            }

                            Text {
                                Layout.fillWidth: true

                                text: root.getActionText(modelData)

                                color: theme.textSecondary
                                font.family: theme.fontMono
                                font.pixelSize: 11
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
            }
        }
    }
}
