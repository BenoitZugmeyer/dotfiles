require("awful.rules")

function slave_raise(c)
    awful.client.swap.byidx(1, c)
end

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
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    { rule = { class = "Amarok" },
      properties = { floating = false, tag = tags[2][2] } },
    { rule_any = { class = {"Choqok", "Pidgin" } },
      properties = { floating = false, tag = tags[2][1] }, callback = awful.client.setslave },
    { rule = { class = "Konsole" },
      callback = slave_raise },
    { rule = { class = "Dolphin" },
      callback = awful.client.floating.toggle },
    { rule = { class = "Dolphin", role = "Dolphin" },
      callback = awful.client.floating.toggle },
}
