------------------
---- MONITORS ----
------------------

-- See https://wiki.hyprland.org/Configuring/Monitors/

-- Left Monitor (DP-2)
hl.monitor({
    output   = "DP-2",
    mode     = "1024x768@60",
    position = "0x0",
    scale    = "1",
})

-- Right Monitor (eDP-1 Laptop)
hl.monitor({
    output   = "eDP-1",
    mode     = "1600x900@60",
    position = "1024x0",
    scale    = "1",
})

-- Fallback rule for any unconfigured/hotplugged display
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})
