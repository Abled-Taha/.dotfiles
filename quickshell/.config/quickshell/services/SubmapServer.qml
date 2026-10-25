import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property string currentSubmap: ""

    function updateKeyMode(data) {
        var mode = data.trim();

        if (mode === "")
            return;

        // MangoWM IPC may return a JSON object or plain text.
        try {
            var result = JSON.parse(mode);

            if (typeof result === "object" && result !== null) {
                mode = result.keymode ?? result.mode ?? mode;
            } else if (typeof result === "string") {
                mode = result;
            }
        } catch (e) {
            // Keep plain-text responses unchanged.
        }

        mode = String(mode).trim();

        if (
            mode === "" ||
            mode === "default" ||
            mode === "global" ||
            mode === "reset"
        ) {
            root.currentSubmap = "";
        } else {
            root.currentSubmap = mode;
        }
    }

    // Read the active mode immediately when Quickshell starts.
    Process {
        id: initialMode

        command: ["mmsg", "get", "keymode"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.updateKeyMode(text)
        }
    }

    // Keep the active mode updated as MangoWM changes modes.
    Process {
        id: keyModeWatcher

        command: ["mmsg", "watch", "keymode"]
        running: true

        stdout: SplitParser {
            onRead: data => root.updateKeyMode(data)
        }

        // Restart the watcher if it exits unexpectedly.
        onRunningChanged: {
            if (!running)
                running = true;
        }
    }
}
