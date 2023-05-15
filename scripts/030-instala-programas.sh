#!/bin/bash
# Script para instalar programas adicionais

# Altera os repositórios para o c3sl
sed -i 's|//archive.ubuntu.com|//br.archive.ubuntu.com|' /etc/apt/sources.list.d/official-package-repositories.list
sed -i 's|//packages.linuxmint.com|//br.packages.linuxmint.com|' /etc/apt/sources.list.d/official-package-repositories.list

# Update e Upgrade inicial:
apt-get update
apt-get -y upgrade

# Tira input da instalação do ttf-mscorefonts-installer
echo '
Name: msttcorefonts/accepted-mscorefonts-eula
Template: msttcorefonts/accepted-mscorefonts-eula
Value: true
Owners: ttf-mscorefonts-installer
Flags: seen
' >>/var/cache/debconf/config.dat

# Instala programas
# Acesso remoto
apt-get install -qyf rdesktop vino openssh-server
# Midia
apt-get install -qyf vlc audacity exfat-fuse shotwell gimp gimp-help-pt drawing inkscape
# Codecs multimida
apt-get install -qyf gstreamer1.0-libav gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-vaapi libavcodec-extra libdvdcss2 libdvdnav4
# Utilitarios e produtividade
apt-get install -qyf vim gedit pdfsam unrar
DEBIAN_FRONTEND=noninteractive apt-get -qyf install ttf-mscorefonts-installer
# SO
apt-get install -qyf ncdu numlockx acct xmlstarlet jq

# Google Chrome
if wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; then
    # Instala dependência
    apt-get -qyf install libu2f-udev
    dpkg -i --force-depends google-chrome-stable_current_amd64.deb
    rm -f google-chrome-stable_current_amd64.deb
fi

# Microsoft Edge
if wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_112.0.1722.39-1_amd64.deb; then
    # Instala dependência
    apt-get -qyf install libu2f-udev
    dpkg -i --force-depends microsoft-edge-stable_112.0.1722.39-1_amd64.deb
    rm -f microsoft-edge-stable_112.0.1722.39-1_amd64.deb
fi

# Zoom
if wget https://zoom.us/client/5.14.5.2430/zoom_amd64.deb; then
    # Instala dependência
    apt-get -qyf install libgl1-mesa-glx libegl1-mesa libxcb-xtest0 ibus libxcb-cursor0
    dpkg -i --force-depends zoom_amd64.deb
    rm -f zoom_amd64.deb
fi

# Atualiza os pacotes recém-instalados
apt-get -y upgrade
