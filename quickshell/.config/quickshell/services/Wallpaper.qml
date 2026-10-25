import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    // Hardcoded wallpaper path (update to your desired image path)
    property string wallpaperPath: "/home/abledtaha/.dotfiles/wallpapers/1.jpg"

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            required property var modelData

            screen: modelData

            // Layer-Shell Configuration: Attach to background layer
            WlrLayershell.layer: WlrLayer.Background

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            // Fallback base color: Solid black
            Rectangle {
                anchors.fill: parent
                color: "#000000"

                Image {
                    id: bgImage
                    anchors.fill: parent
                    source: root.wallpaperPath
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    smooth: true

                    // If loading fails, hide image element so solid black shows
                    onStatusChanged: {
                        if (bgImage.status === Image.Error) {
                            console.warn("[Wallpaper] Failed to load wallpaper at: " + root.wallpaperPath);
                            bgImage.visible = false;
                        }
                    }
                }
            }
        }
    }
}
