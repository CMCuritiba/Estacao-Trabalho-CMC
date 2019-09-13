#!/bin/bash
# Esse script roda por último, criar aqui links em /usr/local/cmc/modificados para qualquer arquivo (ou pasta, se forem muitos) que foram modificados

mkdir -p /usr/local/cmc/modificados

# Skel inteiro basicamente
ln -sf /etc/skel /usr/local/cmc/modificados/skel

# Configs de browsers
ln -sf /usr/lib/firefox-esr/defaults/pref/local-settings.js /usr/local/cmc/modificados/local-settings.js
ln -sf /usr/lib/firefox-esr/mozilla.cfg /usr/local/cmc/modificados/mozilla.cfg
ln -sf /usr/lib/firefox-esr/browser/override.ini /usr/local/cmc/modificados/override.ini
ln -sf /usr/lib/firefox-esr/distribution/distribution.ini /usr/local/cmc/modificados/distribution.ini
ln -sf /etc/opt/chrome/policies/ /usr/local/cmc/modificados/policies

# Coisas no autostart
ln -sf /etc/xdg/autostart/owncloud.desktop /usr/local/cmc/modificados/owncloud.desktop
ln -sf /etc/xdg/autostart/empathy.desktop /usr/local/cmc/modificados/empathy.desktop
ln -sf /etc/xdg/autostart/instant.msg.desktop /usr/local/cmc/modificados/instant.msg.desktop
ln -sf /etc/xdg/autostart/forcelogout.desktop /usr/local/cmc/modificados/forcelogout.desktop

# Bloqueio de execução de alguns programas
ln -sf /usr/bin/mate-terminal /usr/local/cmc/modificados/mate-terminal
ln -sf /usr/bin/mintupdate /usr/local/cmc/modificados/mintupdate
ln -sf /usr/bin/menulibre /usr/local/cmc/modificados/menulibre
ln -sf /usr/bin/mate-desktop-item-edit /usr/local/cmc/modificados/mate-desktop-item-edit
ln -sf /usr/bin/nm-connection-editor /usr/local/cmc/modificados/nm-connection-editor

# dconf
ln -sf /etc/dconf/profile/user /usr/local/cmc/modificados/user
ln -sf /etc/dconf/db/local.d/01-cmc /usr/local/cmc/modificados/01-cmc

# dnsmasq
ln -sf /etc/NetworkManager/NetworkManager.conf /usr/local/cmc/modificados/NetworkManager.conf

# LDAP e PAM
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

# NSSwitch
ln -sf /etc/nsswitch.conf /usr/local/cmc/modificados/nsswitch.conf

# Desabilita TTYs
ln -sf /etc/X11/xorg.conf /usr/local/cmc/modificados/xorg.conf

# Job no cron hourly pra atualizar cache de usuários
ln -sf /etc/cron.hourly/nssupdate.sh /usr/local/cmc/modificados/nssupdate.sh

# Configura retencao do syslog e auth
ln -sf /etc/logrotate.d/rsyslog /usr/local/cmc/modificados/rsyslog

# Configura mensagem de login
ln -sf /etc/profile.d/cmc-profile.sh /usr/local/cmc/modificados/cmc-profile.sh

