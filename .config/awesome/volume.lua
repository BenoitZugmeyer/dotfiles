require('vicious')

local control = config.alsa_control

local function volume_do(cmd)
    awful.util.spawn("amixer set " .. control .. " " .. cmd .. " > /dev/null")
    volume.update()
end

volume = vicious.register(widget({ type = "textbox" }), vicious.widgets.volume,
    function (widget, args)
        if args[2] == "♩" then
            return "Ø"
        else
            return args[1] .. ""
        end
    end, 5, control
)

volume.increase = function() volume_do("5%+") end
volume.decrease = function() volume_do("5%-") end
volume.toggle = function() volume_do("toggle") end

volume.icon = widget({ type="imagebox" })
volume.icon.image = image(config.config_path .. '/theme/vol.png')

volume.widget:buttons(
    awful.util.table.join(
        awful.button({ }, 1, volume.toggle),
        awful.button({ }, 3, function () awful.util.spawn(config.terminal .. " -e alsamixer")   end),
        awful.button({ }, 4, volume.increase),
        awful.button({ }, 5, volume.decrease)
    )
)

