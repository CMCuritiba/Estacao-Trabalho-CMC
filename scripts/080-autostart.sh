#!/bin/bash

# Desabilita o autostart da mensagem de bem vinda, do update manager e mintreport
if [ -e "/etc/xdg/autostart/mintupdate.desktop" ] ; then
    mv /etc/xdg/autostart/mintupdate.desktop /etc/xdg/autostart/mintupdate.desktop.disable
fi

if [ -e "/etc/xdg/autostart/mintwelcome.desktop" ] ; then
    mv /etc/xdg/autostart/mintwelcome.desktop /etc/xdg/autostart/mintwelcome.desktop.disable
fi

if [ -e "/etc/xdg/autostart/mintreport.desktop" ] ; then
    mv /etc/xdg/autostart/mintreport.desktop /etc/xdg/autostart/mintreport.desktop.disable
fi

# Desabilita o autostart para o gnome-keyring
if [ -e "/etc/xdg/autostart/gnome-keyring-pkcs11.desktop" ] ; then
    mv /etc/xdg/autostart/gnome-keyring-pkcs11.desktop /etc/xdg/autostart/gnome-keyring-pkcs11.desktop.disable
fi

if [ -e "/etc/xdg/autostart/gnome-keyring-secrets.desktop" ] ; then
    mv /etc/xdg/autostart/gnome-keyring-secrets.desktop /etc/xdg/autostart/gnome-keyring-secrets.desktop.disable
fi

if [ -e "/etc/xdg/autostart/gnome-keyring-ssh.desktop" ] ; then
    mv /etc/xdg/autostart/gnome-keyring-ssh.desktop /etc/xdg/autostart/gnome-keyring-ssh.desktop.disable
fi

echo '[Desktop Entry]
Type=Application
Terminal=false
Name=ForceLogout
Exec=/usr/local/cmc/scripts/forcelogout.sh
X-GNOME-Autostart-enabled=true' > /etc/xdg/autostart/forcelogout.desktop
