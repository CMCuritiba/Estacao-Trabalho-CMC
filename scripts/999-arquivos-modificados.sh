#!/bin/bash
# Esse script roda por último, criar aqui links em /usr/local/cmc/modificados para qualquer arquivo (ou pasta, se forem muitos) que foram modificados

mkdir -p /usr/local/cmc/modificados

# Skel inteiro basicamente
ln -sf /etc/skel /usr/local/cmc/modificados/skel

# bashrc
ln -sf /root/.bashrc /usr/local/cmc/modificados/bashrc
ln -sf /root/.bash_aliases /usr/local/cmc/modificados/bash_aliases

# Configs de browsers
ln -sf /usr/lib/firefox/defaults/pref/local-settings.js /usr/local/cmc/modificados/local-settings.js
ln -sf /usr/lib/firefox/mozilla.cfg /usr/local/cmc/modificados/mozilla.cfg
ln -sf /usr/lib/firefox/browser/override.ini /usr/local/cmc/modificados/override.ini
ln -sf /usr/lib/firefox/distribution/policies.json \
    /usr/local/cmc/modificados/policies.json
ln -sf /etc/opt/chrome/policies/managed/cmc.json \
    /usr/local/cmc/modificados/chrome-policies-managed-cmc.json
ln -sf /etc/opt/chrome/policies/recommended/cmc.json \
    /usr/local/cmc/modificados/chrome-policies-recommended-cmc.json

# Coisas no autostart
ln -sf /etc/xdg/autostart/forcelogout.desktop /usr/local/cmc/modificados/forcelogout.desktop

# Bloqueio de execução de alguns programas
ln -sf /usr/bin/gnome-terminal /usr/local/cmc/modificados/gnome-terminal
ln -sf /usr/bin/mintupdate /usr/local/cmc/modificados/mintupdate
ln -sf /usr/bin/mintreport /usr/local/cmc/modificados/mintreport
#ln -sf /usr/bin/menulibre /usr/local/cmc/modificados/menulibre
ln -sf /usr/bin/cinnamon-desktop-editor /usr/local/cmc/modificados/cinnamon-desktop-editor
ln -sf /usr/bin/nm-connection-editor /usr/local/cmc/modificados/nm-connection-editor
ln -sf /usr/bin/nm-applet /usr/local/cmc/modificados/nm-applet

# dconf
ln -sf /etc/dconf/profile/user /usr/local/cmc/modificados/user
ln -sf /etc/dconf/db/local.d/01-cmc /usr/local/cmc/modificados/01-cmc

# AD e PAM
ln -sf /etc/pam.d/common-session /usr/local/cmc/modificados/common-session
ln -sf /etc/pam.d/common-auth /usr/local/cmc/modificados/common-auth
ln -sf /etc/pam.d/common-account /usr/local/cmc/modificados/common-account

# Serviço de script após rede
ln -sf /etc/systemd/system/cmc-network-script.service /usr/local/cmc/modificados/cmc-network-script.service

# Imagens novas
ln -sf /usr/share/pixmaps/suporte_tux.png /usr/local/cmc/modificados/suporte_tux.png
ln -sf /usr/share/backgrounds/cmc/desktop-bg.png /usr/local/cmc/modificados/desktop-bg.png

# Servidor NTP
ln -sf /etc/ntp.conf /usr/local/cmc/modificados/ntp.conf

# Configura CUPS
ln -sf /etc/cups/cupsd.conf /usr/local/cmc/modificados/cupsd.conf
ln -sf /etc/cups/cups-browsed.conf /usr/local/cmc/modificados/cups-browsed.conf

# NSSwitch
ln -sf /etc/nsswitch.conf /usr/local/cmc/modificados/nsswitch.conf

# Sudoers
ln -sf /etc/sudoers /usr/local/cmc/modificados/sudoers

# Desabilita TTYs
ln -sf /etc/X11/xorg.conf /usr/local/cmc/modificados/xorg.conf

# Job no cron hourly pra atualizar cache de usuários
ln -sf /etc/cron.hourly/nssupdate /usr/local/cmc/modificados/nssupdate

# Configura retencao do syslog e auth
ln -sf /etc/logrotate.d/rsyslog /usr/local/cmc/modificados/rsyslog

# Scripts de rede
ln -sf /mnt/suporte/etv4/scripts/boot.sh /usr/local/cmc/modificados/boot.sh

# Assegura permissão de montagem de dispositivos externos (pendrives, HDs, etc)
ln -sf /usr/share/polkit-1/actions/org.freedesktop.UDisks2.policy \
    /usr/local/cmc/modificados/org.freedesktop.UDisks2.policy
