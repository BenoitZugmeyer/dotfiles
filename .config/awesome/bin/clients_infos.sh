#!/bin/sh

echo '
local awful = require("awful")
local properties = {
    "class",
    "instance",
    "role",
    "machine",
    "name",
    "alt_name",
    "pid",
}
local str = ""


for _, c in pairs(awful.client.visible()) do
    str = str .. "\n"
    for i, p in ipairs(properties) do
        if c[p] then
            str = str .. p .. ": " .. c[p] .. "\n"
        end
    end
end

return str
' | awesome-client | head -n -1 | tail -n +2
