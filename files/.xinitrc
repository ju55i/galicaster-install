#!/usr/bin/env bash
echo > /tmp/galicaster.log
gnome-settings-daemon &
gnome-session --session=galicaster &
exec /usr/bin/python /usr/share/galicaster/run_galicaster.py
