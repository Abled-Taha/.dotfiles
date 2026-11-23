
import Quickshell
import "./services"
import "./modules"

ShellRoot {
    id: root

    // Feature toggles (disabled by default)
    property bool wallpaper: true
    property bool notifications: true
    property bool submaps: true

    property bool keybinds: false
    property bool commandRunner: false
    property bool launcher: true
    property bool internetSearch: false
    property bool wallpaperSelector: false

    // Wallpaper
    Variants {
        model: root.wallpaper ? [0] : []

        delegate: Wallpaper {}
    }

    // Notifications (Server + UI)
    Variants {
        model: root.notifications ? [0] : []

        delegate: Scope {
            required property var modelData

            NotificationServer {
                id: notifServer
            }

            NotificationPopups {
                notificationServer: notifServer
            }
        }
    }

    // Submaps (Server + UI)
    Variants {
        model: root.submaps ? [0] : []

        delegate: Scope {
            required property var modelData

            SubmapServer {
                id: submapServer
            }

            SubmapIndicator {
                submapServer: submapServer
            }
        }
    }

    // Keybinds
    Variants {
        model: root.keybinds ? [0] : []
        delegate: Keybinds {}
    }

    // Command Runner
    Variants {
        model: root.commandRunner ? [0] : []
        delegate: CommandRunner {}
    }

    // Launcher
    Variants {
        model: root.launcher ? [0] : []
        delegate: Launcher {}
    }

    // Internet Search
    Variants {
        model: root.internetSearch ? [0] : []
        delegate: InternetSearch {}
    }

    // Wallpaper Selector
    Variants {
        model: root.wallpaperSelector ? [0] : []

        delegate: WallpaperSelector {}
    }
}

