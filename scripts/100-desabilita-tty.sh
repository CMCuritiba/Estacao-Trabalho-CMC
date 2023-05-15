#!/bin/bash
# Desabilita a troca de terminals com CTRL + ALT + Fx

if [ ! -f /etc/X11/xorg.conf ] || ! grep -q "Option \"DontVTSwitch\" \"true\"" /etc/X11/xorg.conf; then
echo 'Section "ServerFlags"
    Option "DontVTSwitch" "true"
EndSection' >> /etc/X11/xorg.conf
fi
