require("awful.rules")

local main = tags[1]
local secondary = tags[2]

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },

    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },

    { rule = { class = "Amarok" },
      properties = { floating = false, tag = secondary[2] } },
    { rule_any = { class = {"Choqok", "Pidgin" } },
      properties = { floating = false, tag = secondary[1] }, callback = awful.client.setslave },
    { rule = { class = "Konsole" },
      callback = function (c)
          if launching_cmus then
              awful.client.movetotag(secondary[4], c)
              launching_cmus = false
          else
              awful.client.swap.byidx(1, c)
          end
      end },
    { rule = { class = "Dolphin" }, except = { role = "Dolphin" },
      callback = function (c) awful.client.floating.set(c, true) end },

    { rule = { class = "Amarok" },
      properties = { tag = tags[2][2] } },
    { rule = { class = "XVroot" },
      properties = { floating = true, ontop = true } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
}
