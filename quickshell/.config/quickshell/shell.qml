import Quickshell
import "./services"
import "./modules"

ShellRoot {
    id: root

    // Services
    Wallpaper {}
    NotificationServer {id: notifServer}
    SubmapServer {id: submapServer}

    // UI Modules
    Keybinds {}
    CommandRunner {}
    Launcher {}
    InternetSearch {}
    NotificationPopups {notificationServer: notifServer}
    SubmapIndicator {submapServer: submapServer}
}
