require("awful.rules")

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
      properties = { floating = false, tag = tags[2][2] } },
    { rule_any = { class = {"Choqok", "Pidgin" } },
      properties = { floating = false, tag = tags[2][1] }, callback = awful.client.setslave },
    { rule = { class = "Konsole" },
      callback = function (c) awful.client.swap.byidx(1, c) end },
    { rule = { class = "Dolphin" }, except = { role = "Dolphin" },
      callback = function (c) awful.client.floating.set(c, true) end },

    { rule_any = { class = { "Choqok", "Pidgin" } },
      properties = { tag = tags[2][1] }, callback = awful.client.setslave },
    { rule_any = { class = { "Hotot", "Deluge" } },
      properties = { tag = tags[2][1] } },
    { rule = { class = "Amarok" },
      properties = { tag = tags[2][2] } },
}
