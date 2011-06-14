-- defines mainmenu, launcher

local dbus = 'dbus-send --system --print-reply '

-- local hal = dbus .. "--dest=org.freedesktop.Hal /org/freedesktop/Hal/devices/computer org.freedesktop.Hal.Device.SystemPowerManagement."
-- local suspend = hal .. "Suspend int32:0"
-- local halt = hal .. "Shutdown"
-- local reboot = hal .. "Reboot"

local consolekit = dbus .. '--dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.'
local halt = consolekit ..'Stop'
local reboot = consolekit .. 'Restart'

-- local upower = '--dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.'
-- local suspend = upower .. 'Suspend'
-- local hibernate = upower .. 'Hibernate'


mainmenu = awful.menu({
    items = {
        { "awesome", {
            { "manual", config.terminal .. " -e man awesome" },
            { "edit config", config.editor_cmd .. " -c 'cd " .. config.config_path .. "' " .. config.config_path .. "/rc.lua" },
            { "restart", awesome.restart },
            { "quit", awesome.quit }
        }, beautiful.awesome_icon },
        { "Terminal", config.terminal },
        { "Wiki", config.terminal .. " -e vim -c VimwikiIndex" },
        { "Amarok", "amarok" },
        { "Firefox", config.webbrowser },
        { "Dolphin", "dolphin" },
        { "Restart", reboot },
        { "Stop", halt },
    }
})

launcher = awful.widget.launcher({
    image = image(beautiful.awesome_icon),
    menu = mainmenu
})
