require("awful")
require("awful.autofocus")

require("beautiful")
require("eminent")

config = {
    config_path = awful.util.getdir('config'),
    terminal = "konsole",
    editor = os.getenv("EDITOR") or "vim",
    modkey = "Mod1",
    webbrowser = "firefox-nightly",
    alsa_control = "Front",
}

config.wallpaper_path = config.config_path .. '/wallpaper'
config.editor_cmd = config.terminal .. " -e " .. config.editor,

beautiful.init(config.config_path .. "/theme/theme.lua")

local function load(name)
    dofile(config.config_path .. '/' .. name .. '.lua')
end

load('volume')
load('tags')
load('menu')
load('wibox')
load('input')
load('rules')
load('signals')
