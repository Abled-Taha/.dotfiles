-- Plugins
local config_dir = os.getenv("HOME") .. "/.config/hypr/"
package.path = package.path .. ";" .. config_dir .. "plugins/?.lua;" .. config_dir .. "plugins/?/init.lua"

-- split-monitor-workspaces
local smw = require("split-monitor-workspaces")

smw.setup({
    workspace_count = 10,
    keep_focused = true,
})

require("modules.monitors")
require("modules.binds")
require("modules.autostart")
require("modules.env")
require("modules.decorations")
require("modules.layout")
require("modules.misc")
require("modules.input")
require("modules.windowrules")
