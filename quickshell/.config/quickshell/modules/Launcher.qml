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

    Theme { id: theme }

    // IPC Triggers
    IpcHandler {
        target: "launcher"

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

    function launchApp(app) {
        if (!app) return;

        // Execute native Quickshell entry or wrapper
        if (typeof app.execute === "function") {
            app.execute();
        } else if (app.entry && typeof app.entry.execute === "function") {
            app.entry.execute();
        } else if (app.exec) {
            Quickshell.exec("bash", ["-c", app.exec]);
        }

        root.active = false;
    }

    // Helper function that inspects all possible nested property paths for name
    function getAppName(app) {
        if (!app) return "Unknown Application";
        if (app.name && typeof app.name === "string") return app.name;
        if (app.entry && app.entry.name) return app.entry.name;
        if (app.title) return app.title;
        if (app.id) return app.id;
        return "Unknown Application";
    }

    // Helper function that inspects all possible nested property paths for comment
    function getAppComment(app) {
        if (!app) return "";
        if (app.comment) return app.comment;
        if (app.entry && app.entry.comment) return app.entry.comment;
        if (app.description) return app.description;
        return "";
    }

    // UI Presentation Layer
    Variants {
        model: Quickshell.screens

        delegate: PanelWindowBase {
            required property var modelData

            screen: modelData
            visible: root.active && Quickshell.screens.length > 0 && modelData.name === Quickshell.screens[0].name
            active: root.active
            title: "Applications"

            onVisibleChanged: {
                if (visible) {
                    searchField.text = "";
                    searchField.forceActiveFocus();
                    appList.currentIndex = 0;
                }
            }

            SearchInput {
                id: searchField
                Layout.fillWidth: true
                placeholderText: "Search applications..."

                onTextChanged: {
                    root.filterText = text.toLowerCase();
                    appList.currentIndex = 0;
                }

                Keys.onDownPressed: appList.incrementCurrentIndex()
                Keys.onUpPressed: appList.decrementCurrentIndex()
                Keys.onEscapePressed: root.active = false

                onAccepted: {
                    var model = appList.model;
                    if (model && model.length > 0 && appList.currentIndex >= 0 && appList.currentIndex < model.length) {
                        root.launchApp(model[appList.currentIndex]);
                    }
                }
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ListView {
                    id: appList
                    spacing: 6
                    focus: false

                    model: {
                        var modelObj = DesktopEntries.applications;
                        if (!modelObj) return [];

                        var list = [];

                        // 1. Check if DesktopEntries.applications exposes .values or .items (MapModel)
                        if (modelObj.values) {
                            list = Array.from(modelObj.values);
                        } else if (modelObj.items) {
                            list = Array.from(modelObj.items);
                        } else {
                            // 2. Fallback to key iteration
                            var keys = Object.keys(modelObj);
                            for (var i = 0; i < keys.length; i++) {
                                var item = modelObj[keys[i]];
                                if (item) list.push(item);
                            }
                        }

                        // Sort alphabetically
                        list.sort((a, b) => root.getAppName(a).localeCompare(root.getAppName(b)));

                        return list.filter(app => {
                            if (!app) return false;

                            var noDisp = app.noDisplay || (app.entry && app.entry.noDisplay);
                            if (noDisp) return false;

                            if (!root.filterText) return true;

                            var nameStr = root.getAppName(app).toLowerCase();
                            var commentStr = root.getAppComment(app).toLowerCase();

                            return nameStr.includes(root.filterText) || commentStr.includes(root.filterText);
                        });
                    }

                    delegate: Rectangle {
                        required property var modelData
                        required property int index

                        width: ListView.view.width
                        height: 48
                        color: appList.currentIndex === index ? theme.bgSurfaceSelected : theme.bgSurface
                        radius: theme.radiusItem
                        border.color: appList.currentIndex === index ? theme.borderAccent : theme.borderColor

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: appList.currentIndex = index
                            onClicked: root.launchApp(modelData)
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: root.getAppName(modelData)
                                    color: appList.currentIndex === index ? theme.textAccent : theme.textPrimary
                                    font.bold: true
                                    font.pixelSize: 13
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: root.getAppComment(modelData)
                                    color: theme.textMuted
                                    font.pixelSize: 11
                                    font.family: theme.fontMono
                                    elide: Text.ElideRight
                                    visible: text !== ""
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
