-- defines layouts, tags

layouts = {
--    awful.layout.suit.floating,
--    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
}

local defaultlayouts = {
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
}


-- α β γ δ ε ζ η θ ι κ λ μ ν ξ ο π ρ σ τ υ φ χ ψ ω

tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ "α", "β", "γ", "δ", "ε" }, s, defaultlayouts[s])
end
awful.tag.setmwfact(0.618, tags[1][1])
