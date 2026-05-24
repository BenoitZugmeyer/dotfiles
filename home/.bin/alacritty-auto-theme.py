#!/usr/bin/env python3
import sys
import re
import subprocess
import signal
from pathlib import Path

ALACRITTY_CONFIG = Path.home() / ".config/alacritty/alacritty.toml"

def main() -> None:
    out = subprocess.check_output(
        [
            "dbus-send",
            "--session",
            "--print-reply=literal",
            "--dest=org.freedesktop.portal.Desktop",
            "/org/freedesktop/portal/desktop",
            "org.freedesktop.portal.Settings.Read",
            "string:org.freedesktop.appearance",
            "string:color-scheme",
        ],
        text=True,
    )
    set_theme(parse_theme(out))

    proc = subprocess.Popen(
        [
            "dbus-monitor",
            "--session",
            ",".join([
                "type=signal",
                "interface=org.freedesktop.portal.Settings",
                "member=SettingChanged",
                "path=/org/freedesktop/portal/desktop",
                "arg0='org.freedesktop.appearance'",
                "arg1='color-scheme'",
            ])
        ],
        stdout=subprocess.PIPE,
        text=True,
    )
 
    def _shutdown(*_):
        proc.terminate()
        sys.exit(0)
 
    signal.signal(signal.SIGTERM, _shutdown)
    signal.signal(signal.SIGINT, _shutdown)
 
    for line in proc.stdout:
        theme = parse_theme(line)
        if theme is not None: set_theme(theme)

def parse_theme(s: str) -> str | None:
    m = re.search(r'(?<=uint32\s)\d+', s)
    return (
        None if m is None else
        "dark" if m.group(0) == "1" else
        "light"
    )

def set_theme(name: str) -> None:
    text = ALACRITTY_CONFIG.read_text()

    def replace(match):
        config_line = match.group(1)
        return config_line if match.group(2) == name else '#' + config_line
    text = re.sub(r'(?:#)?(\S.*# (\w+) theme)', replace, text)

    ALACRITTY_CONFIG.write_text(text)

if __name__ == "__main__":
    main()
