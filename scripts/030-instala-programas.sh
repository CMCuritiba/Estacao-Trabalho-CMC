#!/bin/bash
# Script para instalar programas adicionais

# Altera os repositórios para o c3sl
sed -i 's|//archive.ubuntu.com|//br.archive.ubuntu.com|' /etc/apt/sources.list.d/official-package-repositories.list
sed -i 's|//packages.linuxmint.com|//br.packages.linuxmint.com|' /etc/apt/sources.list.d/official-package-repositories.list

# Adicionar os repositórios necessários:
add-apt-repository -y ppa:starws-box/deadbeef-player
add-apt-repository -y ppa:mozillateam/ppa

# Update e Upgrade inicial:
apt-get update
apt-get -y upgrade

# Instala programas
# Acesso remoto
apt-get install -qyf rdesktop vino openssh-server
# Midia
apt-get install -qyf deadbeef vlc audacity exfat-fuse exfat-utils shotwell gthumb gimp-help-pt drawing
# Navegacao
apt-get install -qyf firefox-esr firefox-esr-locale-pt
# Utilitarios e produtividade
apt-get install -qyf vim gedit pdfsam unrar ttf-mscorefonts-installer
# SO
apt-get install -qyf ncdu numlockx acct

# Chrome, pq chrome é especial:
if ! dpkg-query -l google-chrome-stable &>/dev/null; then
    if ! wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; then
        logger "Não foi possível baixar o Google Chrome."
        exit 1
    fi
    dpkg -i --force-depends google-chrome-stable_current_amd64.deb
fi

apt-get -qyf upgrade
rm -rf google-chrome-stable_current_amd64.deb
