#!/bin/bash

# Script deve ser rodado como root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    logger "Este script deve ser executado como root"
    exit 1
fi

# Desativa pop-up no boot
if [ -e "/etc/xdg/autostart/instant.msg.desktop" ]; then
    mv -f /etc/xdg/autostart/instant.msg.desktop /etc/xdg/autostart/instant.msg.desktop.disable
fi
