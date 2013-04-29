#!/usr/bin/env bash
echo > /tmp/galicaster.log
gnome-settings-daemon &
gnome-session --session=galicaster &
x11vnc -localhost -forever -display :0 &
exec /usr/bin/python /usr/share/galicaster/run_galicaster.py
