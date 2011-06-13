-- failsafe mode: if the current config fail, load the default rc.lua

require("awful")
require("naughty")

confdir = awful.util.getdir("config")
local rc, err = loadfile(confdir .. "/init.lua");
if rc then
    rc, err = pcall(rc);
end

if not rc then
    dofile("/etc/xdg/awesome/rc.lua");

    naughty.notify{
        text="<b>Awesome crashed during startup</b>\n" .. err,
        timeout = 0}
end
