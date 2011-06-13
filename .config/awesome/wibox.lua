require("vicious")
require("vicious.widgets.bat")
require("vicious.widgets.pkg")
require("vicious.widgets.gmail")
require('awful.remote')
local textclock = awful.widget.textclock({ align = "right" })
local systray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
promptbox = {}
local layoutbox = {}
local taglist = {
    buttons = awful.util.table.join(
        awful.button({ },               1, awful.tag.viewonly),
        awful.button({ config.modkey }, 1, awful.client.movetotag),
        awful.button({ },               3, awful.tag.viewtoggle),
        awful.button({ config.modkey }, 3, awful.client.toggletag),
        awful.button({ },               4, awful.tag.viewnext),
        awful.button({ },               5, awful.tag.viewprev)
    )
}

local tasklist = {
    buttons = awful.util.table.join(

        awful.button({ }, 1, function (c)
            if c == client.focus then
                c.minimized = true
            else
                if not c:isvisible() then
                    awful.tag.viewonly(c:tags()[1])
                end
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
        end)
    )
}

local spacer = widget({ type = "textbox"})
spacer.text = " "

function createWidget(wtype, iconpath, format, timer, arg)
    local result = {}
    result.widget = widget({ type = "textbox" })
    result.rel = vicious.register(result.widget, wtype, format, timer, arg)
    result.icon = widget({ type="imagebox" })
    result.icon.image = image(config.config_path .. "/theme/" .. iconpath, iconpath)
    local bt = awful.button({ }, 1, function() result.rel.update() end)
    result.icon:buttons(awful.util.table.join(bt))
    result.widget:buttons(awful.util.table.join(bt))
    return result
end

gmail = createWidget(vicious.widgets.gmail, 'mail.png',
    function (widget, args)
        local result = args["{count}"]
        if args["{subject}"] ~= "N/A" and args["{count}"] ~= 0 then
            result = result .. ' ' .. args["{subject}"]
        end
        return result
    end,
    200, { 100, "gmailwidget" })

packages = createWidget(vicious.widgets.pkg, "pacman.png",
    "$1", 3600, "Arch")
packages.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function() 
        awful.util.spawn_with_shell(config.terminal .. " -e " .. config.config_path .. "/bin/update")
    end)
))

weather = createWidget(vicious.widgets.weather, 'temp.png',
    function(widget, args)
        local result = args['{tempc}']..'°'
        if args["{weather}"] ~= 'N/A' then
            result = result .. ' ' .. args["{weather}"]:lower():gsub(" observed$", ""):gsub("( ?%w+us) clouds", "%1")
            args["{weather}"] = 'N/A' -- prevent the widget to show previous weather when no weather is returned
        end
        return result
    end,
    900, 'LFPB') -- Paris


local wibox

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    promptbox[s] = awful.widget.prompt({
        layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end))
    )

    -- Create a taglist widget
    taglist[s] = awful.widget.taglist(
        s, awful.widget.taglist.label.all, taglist.buttons)

    -- Create a tasklist widget
    tasklist[s] = awful.widget.tasklist(
        function(c) return awful.widget.tasklist.label.currenttags(c, s) end,
        tasklist.buttons
    )



    -- Create the wibox
    wibox = awful.wibox({ position = "top", screen = s, height = 16 })
    -- Add widgets to the wibox - order matters
    wibox.widgets = {
        {
            launcher,
            taglist[s],
            promptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        layoutbox[s],
        textclock,
        s == 1 and systray or nil, spacer,
        gmail.widget, gmail.icon, spacer,
        packages.widget, packages.icon, spacer,
        weather.widget, weather.icon, spacer,
        volume.widget, volume.icon, spacer,
        tasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
