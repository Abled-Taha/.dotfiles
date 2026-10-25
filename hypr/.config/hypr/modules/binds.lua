local smw = require("split-monitor-workspaces")

---------------------
---- MY PROGRAMS ----
---------------------

local terminal              = "alacritty"
local file_manager          = string.format("%s -e spf", terminal)
local browser               = "librewolf"
local text_editor           = string.format("%s -e vim", terminal)
local system_monitor        = string.format("%s -e btop", terminal)
local games_launcher        = "flatpak run com.heroicgameslauncher.hgl"
local minecraft_launcher    = "prismlauncher"
local ide		            = "zeditor"

local STORAGE		        = "/mnt/Storage"
local PROJECTS		        = string.format("%s/Documents/Projects", STORAGE)
local PROJECTSLOCAL	        = "~/Projects"
local DOTFILES		        = "~/.dotfiles"

local rimworld 		        = string.format("%s/Games/RimWorld_5_DLC_1.6.4871_Linux_GOG/start.sh", STORAGE)
local sober                 = "flatpak run org.vinegarhq.Sober"
local combat_master         = "steam steam://rungameid/2281730"

---------------------
---- KEYBINDINGS ----
---------------------

local main_mod = "SUPER"

-- Global Mouse Binds (Move & Resize windows with mouse anywhere)
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "Allows to move window" })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Allows to resize window" })

-- Hyprland Submap (Single-shot)
hl.bind(main_mod .. " + H", hl.dsp.submap("hyprland"), { description = "Open Hyprland submap" })
hl.define_submap("hyprland", "reset", function ()
    hl.bind("R", hl.dsp.exec_cmd("hyprctl reload"), { description = "Hyprland: Reloads Hyprland config" })
    hl.bind("Q", hl.dsp.exit(), { description = "Hyprland: Quits Hyprland" })

    -- Escape / Return exits back to global normal mode
    hl.bind("Escape", hl.dsp.submap("reset"), { description = "Hyprland: Reset to Global submap" })
    hl.bind("Return", hl.dsp.submap("reset"), { description = "Hyprland: Reset to Global submap" })
end)

-- Special Submap (Single-shot)
hl.bind(main_mod .. " + S", hl.dsp.submap("special"), { description = "Open Special submap" })
hl.define_submap("special", "reset", function ()
    hl.bind("S", hl.dsp.exec_cmd("shutdown now"), { description = "Special: Shutdown" })
    hl.bind("R", hl.dsp.exec_cmd("shutdown -r now"), { description = "Special: Restart" })
    hl.bind("L", hl.dsp.exec_cmd("~/.dotfiles/scripts/screen_toggle.sh"), { description = "Special: Toggle display" })
    hl.bind("P", hl.dsp.exec_cmd("~/.dotfiles/scripts/screenshot.sh"), { description = "Special: Screenshot" })
    hl.bind("C", hl.dsp.exec_cmd("~/.dotfiles/scripts/clock.sh"), { description = "Current Date/Time" })

    -- Escape / Return exits back to global normal mode
    hl.bind("Escape", hl.dsp.submap("reset"), { description = "Special: Reset to Global submap" })
    hl.bind("Return", hl.dsp.submap("reset"), { description = "Special: Reset to Global submap" })
end)

-- Window Submap (Persistent until explicitly exited or key action)
hl.bind(main_mod .. " + W", hl.dsp.submap("window"), { description = "Open Window submap" })
hl.define_submap("window", function ()
    hl.bind("W", hl.dsp.window.move({ direction = "up" }), { description = "Window: Move/Swap window up" })
    hl.bind("A", hl.dsp.window.move({ direction = "left" }), { description = "Window: Move/Swap window left" })
    hl.bind("S", hl.dsp.window.move({ direction = "down" }), { description = "Window: Move/Swap window down" })
    hl.bind("D", hl.dsp.window.move({ direction = "right" }), { description = "Window: Move/Swap window right" })

    hl.bind("Q", hl.dsp.window.close(), { description = "Window: Close Application" })
    hl.bind("T", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Toggle floating window" })
    hl.bind("F", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }), { description = "Window: Toggle fullscreen window" })

    -- Submap for Resizing (Persistent)
    hl.bind("R", hl.dsp.submap("resize"), { description = "Window: Open Resize submap" })

    -- Escape / Return exits back to global normal mode
    hl.bind("Escape", hl.dsp.submap("reset"), { description = "Window: Reset to Global submap" })
    hl.bind("Return", hl.dsp.submap("reset"), { description = "Window: Reset to Global submap" })
end)

-- Resize Submap
hl.define_submap("resize", function ()
    hl.bind("W", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true, description = "Resize: Resize window towards up" })
    hl.bind("A", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true, description = "Resize: Resize window towards left" })
    hl.bind("S", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true, description = "Resize: Resize window towards down" })
    hl.bind("D", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true, description = "Resize: Resize window towards right" })

    -- Escape / Return exits back to global normal mode
    hl.bind("Escape", hl.dsp.submap("reset"), { description = "Resize: Reset to Global submap" })
    hl.bind("Return", hl.dsp.submap("reset"), { description = "Resize: Reset to Global submap" })
end)

-- Focus Movement
hl.bind(main_mod .. " + A", hl.dsp.focus({ direction = "left" }), { description = "Move focus left" })
hl.bind(main_mod .. " + D", hl.dsp.focus({ direction = "right" }), { description = "Move focus right" })

-- System Apps Submap (Single-shot)
hl.bind(main_mod .. " + SPACE", hl.dsp.submap("system_apps"), { description = "Open SystemApps submap" })
hl.define_submap("system_apps", "reset", function ()
    hl.bind("SPACE", hl.dsp.exec_cmd("quickshell msg launcher toggle"), { description = "SystemApps: Open Application Launcher" })
    hl.bind("RETURN", hl.dsp.exec_cmd(terminal), { description = "SystemApps: Open Terminal" })
    hl.bind("R", hl.dsp.exec_cmd("quickshell msg runner toggle"), { description = "SystemApps: Toggle Command Runner panel" })
    hl.bind("F", hl.dsp.exec_cmd(file_manager), { description = "SystemApps: Open File Manager" })
    hl.bind("T", hl.dsp.exec_cmd(system_monitor), { description = "SystemApps: Open System Monitor" })

    -- Escape / Return exits back to global normal mode
    hl.bind("Escape", hl.dsp.submap("reset"), { description = "SystemApps: Reset to Global submap" })
end)

-- User Apps Submap (Single-shot)
hl.bind(main_mod .. " + RETURN", hl.dsp.submap("user_apps"), { description = "Open UserApps submap" })
hl.define_submap("user_apps", "reset", function ()
    hl.bind("T", hl.dsp.exec_cmd(text_editor), { description = "UserApps: Open Text Editor" })
    hl.bind("B", hl.dsp.submap("browser_apps"), { description = "UserApps: Open BrowserApps submap" })
    hl.bind("G", hl.dsp.submap("games"), { description = "UserApps: Open Games submap" })
    hl.bind("C", hl.dsp.submap("programming"), { description = "UserApps: Open Programming submap" })

    -- Escape / Return exits back to global normal mode
    hl.bind("Escape", hl.dsp.submap("reset"), { description = "UserApps: Reset to Global submap" })
    hl.bind("Return", hl.dsp.submap("reset"), { description = "UserApps: Reset to Global submap" })
end)

-- Games (Single-shot)
hl.define_submap("games", "reset", function ()
    hl.bind("G", hl.dsp.exec_cmd(games_launcher), { description = "Games: Open Games Launcher" })
    hl.bind("M", hl.dsp.exec_cmd(minecraft_launcher), { description = "Games: Open Minecraft Launcher" })
    hl.bind("R", hl.dsp.exec_cmd(rimworld), { description = "Games: Open RimWorld" })
    hl.bind("S", hl.dsp.exec_cmd(sober), { description = "Games: Open Sober" })
    hl.bind("C", hl.dsp.exec_cmd(combat_master), { description = "Games: Open Comabat Master" })

    -- Escape / Return exits back to global normal mode
    hl.bind("Escape", hl.dsp.submap("reset"), { description = "Games: Reset to Global submap" })
    hl.bind("Return", hl.dsp.submap("reset"), { description = "Games: Reset to Global submap" })
end)

-- Programming (One-shot)
hl.define_submap("programming", "reset", function ()
    hl.bind("C", hl.dsp.exec_cmd(ide), { description = "Programming: Open IDE" })
    hl.bind("1", hl.dsp.exec_cmd(string.format("%s %s", ide, DOTFILES)), { description = "Programming: Open IDE/.dotfiles" })
    hl.bind("2", hl.dsp.exec_cmd(string.format("%s %s/programming/ironbook", ide, PROJECTSLOCAL)), { description = "Programming: Open IDE/ironbook" })

    -- Escape / Return exits back to global normal mode
    hl.bind("Escape", hl.dsp.submap("reset"), { description = "Programming: Reset to Global submap" })
    hl.bind("Return", hl.dsp.submap("reset"), { description = "Programming: Reset to Global submap" })
end)

-- Browser Apps Submap (Single-shot)
hl.define_submap("browser_apps", "reset", function ()
    hl.bind("SPACE", hl.dsp.exec_cmd("quickshell msg internet_search toggle"), { description = "BrowserApps: Open InternetSearch panel" })
    hl.bind("B", hl.dsp.exec_cmd(browser), { description = "BrowserApps: Open Browser" })
    hl.bind("SHIFT + B", hl.dsp.exec_cmd(string.format("%s --private-window", browser)), { description = "BrowserApps: Open Browser in Incognito" })
    hl.bind("G", hl.dsp.exec_cmd(string.format("%s gemini.google.com", browser)), { description = "BrowserApps: Open Gemini" })
    hl.bind("Y", hl.dsp.exec_cmd(string.format("%s youtube.com", browser)), { description = "BrowserApps: Open YouTube" })
    hl.bind("W", hl.dsp.exec_cmd(string.format("%s web.whatsapp.com", browser)), { description = "BrowserApps: Open WhatsApp Web" })
    hl.bind("M", hl.dsp.exec_cmd(string.format("%s gmail.com", browser)), { description = "BrowserApps: Open Gmail" })
    hl.bind("C", hl.dsp.submap("browser_apps_github"), { description = "BrowserApps: Open BrowserAppsGithub submap" })

    -- Escape / Return exits back to global normal mode
    hl.bind("Escape", hl.dsp.submap("reset"), { description = "BrowserApps: Reset to Global submap" })
    hl.bind("Return", hl.dsp.submap("reset"), { description = "BrowserApps: Reset to Global submap" })
end)

-- Browser Apps Submap (Single-shot): GitHub
hl.define_submap("browser_apps_github", "reset", function ()
    hl.bind("C", hl.dsp.exec_cmd(string.format("%s github.com", browser)), { description = "BrowserAppsGithub: Open GitHub" })
    hl.bind("1", hl.dsp.exec_cmd(string.format("%s github.com/Abled-Taha", browser)), { description = "BrowserAppsGithub: Open GitHub/Abled-Taha" })
    hl.bind("2", hl.dsp.exec_cmd(string.format("%s github.com/Abled-Taha/ironbook", browser)), { description = "BrowserAppsGithub: Open GitHub/Abled-Taha/ironbook" })

    -- Escape / Return exits back to global normal mode
    hl.bind("Escape", hl.dsp.submap("reset"), { description = "BrowserAppsGithub: Reset to Global submap" })
    hl.bind("Return", hl.dsp.submap("reset"), { description = "BrowserAppsGithub: Reset to Global submap" })
end)

-- Global Workspaces Loop
for i = 1, smw.get_amount_of_workspaces() do
    local key_label = (i == 10) and "0" or tostring(i)
    hl.bind(main_mod .. " + " .. key_label, smw.workspace(tostring(i)), { description = string.format("Switch to workspace %s", i) })
    hl.bind(main_mod .. " + ALT + " .. key_label, smw.move_to_workspace_silent(tostring(i)), { description = string.format("Move window silently to workspace %s", i) })
    hl.bind(main_mod .. " + SHIFT + " .. key_label, smw.move_to_workspace(tostring(i)), { description = string.format("Move window to workspace %s", i) })
end

-- Scratchpad
hl.bind(main_mod .. " + GRAVE", hl.dsp.workspace.toggle_special("magic"), { description = "Open Scratchpad" })
hl.bind(main_mod .. " + SHIFT + GRAVE", hl.dsp.window.move({ workspace = "special:magic" }), { description = "Move Window to Scratchpad" })

-- Monitor Focus
hl.bind(main_mod .. " + CTRL + A", hl.dsp.focus({ monitor = "left" }), { description = "Move focus to left monitor" })
hl.bind(main_mod .. " + CTRL + D", hl.dsp.focus({ monitor = "right" }), { description = "Move focus to right monitor" })

-- Quickshell
hl.bind(main_mod .. " + SLASH", hl.dsp.exec_cmd("quickshell msg keybinds toggle"), { description = "Toggle Keybinds panel" })

-- Media / Hardware Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),     { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
