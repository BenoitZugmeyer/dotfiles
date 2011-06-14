require("naughty")

local modkey = config.modkey

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

local function spawn(cmd)
    return function () awful.util.spawn(cmd) end
end

globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Next",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Prior",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

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
    awful.key({ modkey,           }, "w", function () mainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "Left",  function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "Left",  function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "Right", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u",     awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",   function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),
    -- awful.key({ 'any' }, modkey, nil, stopfocus),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(config.terminal) end),
    awful.key({ modkey,           }, "!", function () awful.util.spawn(config.terminal .. " -e vim vi -c VimwikiIndex") end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    awful.key({ modkey,           }, "Up",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "Down",   function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "Up",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "Down",   function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "Up",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "Down",   function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",      function () promptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  promptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    awful.key({}, '#121', volume.toggle),
    awful.key({}, '#122', volume.decrease),
    awful.key({}, '#123', volume.increase),
    awful.key({}, '#180', spawn('firefox-nightly')),
    awful.key({}, '#163', spawn('thunderbird')),
    awful.key({}, '#225', spawn('dolphin')),
    awful.key({ modkey }, 'F12', spawn(config.config_path .. '/bin/i3lock -i ' .. config.wallpaper_path))
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),

    awful.key({ modkey }, "a", function (c)
        print("role      " .. (c.role or 'Nil'))
        print("class     " .. (c.class or 'Nil'))
        print("window    " .. (c.window or 'Nil'))
        print("type      " .. (c.type or 'Nil'))
        print("transient " .. (c.transient_for and 'Y' or 'nil'))
        print('-')
        io.stdout:flush()
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
   keynumber = math.min(9, math.max(#tags[s], keynumber));
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
