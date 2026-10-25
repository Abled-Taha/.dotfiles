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

    Theme { id: theme }

    // Reusable process object for execution
    Process {
        id: runnerProc
    }

    IpcHandler {
        target: "runner"

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

    function launchCommand(cmd) {
        var trimmed = cmd ? cmd.trim() : "";
        if (trimmed === "")
            return;

        // Execute natively via bash using Quickshell.Io Process
        runnerProc.command = ["bash", "-c", trimmed];
        runnerProc.running = true;

        root.active = false;
    }

    Variants {
        model: Quickshell.screens

        delegate: PanelWindowBase {
            required property var modelData

            screen: modelData

            // Show the runner on the first available screen.
            visible: root.active
                && Quickshell.screens.length > 0
                && modelData.name === Quickshell.screens[0].name

            active: root.active
            title: "Run Command"

            panelHeight: 120

            onVisibleChanged: {
                if (visible) {
                    searchField.text = "";
                    searchField.forceActiveFocus();
                }
            }

            SearchInput {
                id: searchField

                Layout.fillWidth: true
                placeholderText: "Type a command..."

                Keys.onEscapePressed: root.active = false

                onAccepted: {
                    root.launchCommand(text);
                }
            }
        }
    }
}
