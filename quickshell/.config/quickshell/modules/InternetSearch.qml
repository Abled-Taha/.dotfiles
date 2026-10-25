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

    // IPC Trigger: quickshell msg search toggle
    IpcHandler {
        target: "internet_search"

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

    function executeSearch(query) {
        var trimmed = query ? query.trim() : "";
        if (trimmed === "")
            return;

        // Encode the search query safely for the URL.
        var encodedQuery = encodeURIComponent(trimmed);
        var searchUrl = "https://www.google.com/search?q=" + encodedQuery;

        // Open the URL in the default browser.
        Qt.openUrlExternally(searchUrl);

        root.active = false;
    }

    // UI Presentation Layer
    Variants {
        model: Quickshell.screens

        delegate: PanelWindowBase {
            required property var modelData

            screen: modelData

            // Show the search panel on the first available screen.
            visible: root.active
                && Quickshell.screens.length > 0
                && modelData.name === Quickshell.screens[0].name

            active: root.active
            title: "Web Search"

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
                placeholderText: "Search on Google..."

                Keys.onEscapePressed: root.active = false

                onAccepted: {
                    root.executeSearch(text);
                }
            }
        }
    }
}
