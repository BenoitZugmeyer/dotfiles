-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

local vicious = require("vicious")

-- {{{ Error handling
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
confpath = awesome.conffile:match("(.*)/[^/]*$")

beautiful.init(confpath .. "/theme/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "konsole"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
--  awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
--  awful.layout.suit.tile.top,
    awful.layout.suit.fair,
--  awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
--  awful.layout.suit.spiral.dwindle,
--  awful.layout.suit.max,
--  awful.layout.suit.max.fullscreen,
--  awful.layout.suit.magnifier
}

-- }}}

-- {{{ Util

local function spawn(cmd)
    return function () awful.util.spawn(cmd) end
end

require("lfs")
local function processwalker()
   local function yieldprocess()
      for dir in lfs.dir("/proc") do
        -- All directories in /proc containing a number, represent a process
        if tonumber(dir) ~= nil then
          local f, err = io.open("/proc/"..dir.."/cmdline")
          if f then
            local cmdline = f:read("*all")
            f:close()
            if cmdline ~= "" then
              coroutine.yield(cmdline)
            end
          end
        end
      end
    end
    return coroutine.wrap(yieldprocess)
end

local function run_once(process, cmd)
   assert(type(process) == "string")
   local regex_killer = {
      ["+"]  = "%+", ["-"] = "%-",
      ["*"]  = "%*", ["?"]  = "%?" }

   for p in processwalker() do
      if p:find(process:gsub("[-+?*]", regex_killer)) then
          return
      end
   end
   return awful.util.spawn(cmd or process)
end

-- Use the second argument, if the programm you wanna start,
-- differs from the what you want to search.
--run_once("redshift", "nice -n19 redshift -l 51:14 -t 5700:4500")

-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.tiled(beautiful.wallpaper, s)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- α β γ δ ε ζ η θ ι κ λ μ ν ξ ο π ρ σ τ υ φ χ ψ ω
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "α", "β", "γ", "δ", "ε" }, s, layouts[1])
    awful.tag.setmwfact(0.618, tags[s][1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
function systemctl (what)
    return 'sudo systemctl ' .. what
end

myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Suspend", systemctl('suspend') },
                                    { "Restart", systemctl('reboot') },
                                    { "Stop", systemctl('poweroff') },
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Volume control
do
    local function volume_do(cmd)
        awful.util.spawn("amixer set Master " .. cmd .. " > /dev/null")
        mywidgets.volume.update()
    end

    volume = {}
    volume.increase = function() volume_do("5%+") end
    volume.decrease = function() volume_do("5%-") end
    volume.toggle = function() volume_do("toggle") end
    volume.muted = function()
        return not io.popen('amixer get Master'):read('*a'):match('%[on%]')
    end
    volume.mute = function(y)
        if y or y == nil then
            volume_do('mute')
        else
            volume_do('unmute')
        end
    end
end
-- }}}

-- {{{ Wibox

local spacer = wibox.widget.textbox()
spacer:set_text(" ")

function createwidget(options)
    local result = {}

    local widget = wibox.widget.textbox()
    local rel = vicious.register(
        widget,
        options.type,
        options.format,
        options.timer,
        options.arg
        )
    local icon

    if options.icon then
        icon = wibox.widget.imagebox()
        icon:set_image(confpath .. "/theme/icons/" .. options.icon)
    end

    local buttons = options.buttons or {
        awful.button({ }, 1, function() result.update() end)
    }
    widget:buttons(awful.util.table.join(unpack(buttons)))
    if icon then
        icon:buttons(awful.util.table.join(unpack(buttons)))
    end

    result = {
        add = function (panel)
            if icon then
                panel:add(icon)
            end
            panel:add(widget)
            panel:add(spacer)
        end,
        update = function ()
            rel.update()
        end
    }

    return result
end

mywidgets = {}

mywidgets.clock = createwidget{
    type = vicious.widgets.date,
    format = "%b %d, %R",
    timer = 60
}

mywidgets.mail = createwidget{
    type = vicious.widgets.gmail,
    icon = 'mail.png',
    format = function (widget, args)
        local result = args["{count}"]
        function decode(l)
            return string.gsub(l,"&amp;", '&')
        end
        if args["{subject}"] ~= "N/A" and args["{count}"] ~= 0 then
            result = result .. ' ' .. decode(args["{subject}"])
        end
        return result
    end,
    timer = 200,
    arg = { 100, "gmailwidget" }
}

mywidgets.pacman = createwidget{
    type = vicious.widgets.pkg,
    icon = "pacman.png",
    format = "$1",
    timer = 3600,
    arg = "Arch",
    buttons = {
        awful.button({ }, 1, function ()
            awful.util.spawn_with_shell(terminal .. " -e " .. confpath .. "/bin/update")
        end)
    }
}

mywidgets.weather = createwidget{
    type = vicious.widgets.weather,
    icon = 'temp.png',
    format = function(widget, args)
        local result = args['{tempc}']..'°'
        if args["{weather}"] ~= 'N/A' then
            result = result .. ' ' .. args["{weather}"]:lower():gsub(" observed$", ""):gsub("( ?%w+us) clouds", "%1")
            args["{weather}"] = 'N/A' -- prevent the widget to show previous weather when no weather is returned
        end
        return result
    end,
    timer = 900,
    arg = 'LFPB' -- Paris
}

mywidgets.volume = createwidget{
    type = vicious.widgets.volume,
    icon = "vol.png",
    format = function (widget, args)
        if args[2] == "♩" then
            return "Ø"
        else
            return args[1] .. ""
        end
    end,
    timer = 5,
    arg = "Master",
    buttons = {
        awful.button({ }, 1, volume.toggle),
        awful.button({ }, 3, spawn(terminal .. " -e alsamixer")),
        awful.button({ }, 4, volume.increase),
        awful.button({ }, 5, volume.decrease)
    }
}

mywidgets.battery = createwidget{
    type = vicious.widgets.bat,
    arg = 'BAT0',
    icon = 'bat.png',
    format = function(widget, args)
        return args[1] .. args[2] .. '%'
    end,
    timer = 60
}

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 16 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    mywidgets.volume.add(right_layout)
    mywidgets.weather.add(right_layout)
    mywidgets.pacman.add(right_layout)
    mywidgets.mail.add(right_layout)
    mywidgets.battery.add(right_layout)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(spacer)
    mywidgets.clock.add(right_layout)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Next",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Prior",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "grave", awful.tag.history.restore),

    awful.key({ modkey,           }, "Right",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "Left",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "Left",  function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "Left",  function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "Right", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", spawn(terminal)),
    awful.key({ modkey,           }, ".",      spawn(terminal .. " -e vim vi -c VimwikiIndex")),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "Up",    function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "Down",  function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "Up",    function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "Down",  function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "Up",    function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "Down",  function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Shift" }, "n", function ()
        local client = awful.client.restore()
        if client then
            awful.client.jumpto(client, true)
        end
    end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

    awful.key({}, '#121', volume.toggle),
    awful.key({}, '#122', volume.decrease),
    awful.key({}, '#123', volume.increase),
    awful.key({}, 'XF86AudioPlay', function ()
        paused = io.popen('mpc --format ""'):read(8):match('paused')
        if paused then
            awful.util.spawn('mpc play')
        else
            awful.util.spawn('mpc pause')
        end
    end),
    awful.key({}, 'XF86AudioNext', spawn('mpc next')),
    awful.key({}, 'XF86AudioPrev', spawn('mpc prev')),
    awful.key({}, '#180', spawn('firefox-nightly')),
    awful.key({}, '#163', spawn('thunderbird')),
    awful.key({}, '#225', spawn('dolphin')),
    awful.key({ modkey }, 'F12', function ()
        local muted = volume.muted()
        volume.mute()
        awful.util.spawn('mpc pause')
        awful.util.pread('i3lock -n -i ' .. beautiful.wallpaper)
        volume.mute(muted)
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "i",      function (c) awful.client.incwfact(0.1, c)    end),
    awful.key({ modkey, "Shift"   }, "i",      function (c) awful.client.incwfact(-0.1, c)   end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Konsole" },
      callback = function (c)
        awful.client.swap.byidx(1, c)
      end },
    { rule = { class = "Dolphin" }, except = { role = "Dolphin" },
      callback = function (c) awful.client.floating.set(c, true) end },
    { rule = { class = "XVroot" },
      properties = { floating = true, ontop = true } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    { rule = { class = "Steam" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Autostart

-- Add your applications here
--run_once("firefox-nightly")
--run_once("hotot")

-- }}}
-- vim: foldmethod=marker:foldlevel=0
