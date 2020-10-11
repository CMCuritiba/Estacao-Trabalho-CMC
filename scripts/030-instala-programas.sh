#!/bin/bash
# Script para instalar programas adicionais

# Altera os repositórios para o c3sl
sed -i 's|//archive.ubuntu.com|//br.archive.ubuntu.com|' /etc/apt/sources.list.d/official-package-repositories.list
sed -i 's|//packages.linuxmint.com|//br.packages.linuxmint.com|' /etc/apt/sources.list.d/official-package-repositories.list

# Adicionar os repositórios necessários:
add-apt-repository -y ppa:starws-box/deadbeef-player
add-apt-repository -y ppa:mozillateam/ppa

# Adiciona repositório do ownCloud:

if [ -f "/etc/upstream-release/lsb-release" ]; then
	source "/etc/upstream-release/lsb-release";
fi;

#Não colocaram repositório do OwnCloud para o Mint 20 (Verificado dia 30/09/2020)
if [ -z "$DISTRIB_ID" ]; then
	DISTRIB_ID=Ubuntu
fi;

if [ -z "$DISTRIB_RELEASE" ]; then
	DISTRIB_RELEASE=20.04
fi;

echo "deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/${DISTRIB_ID}_${DISTRIB_RELEASE}/ /" > "/etc/apt/sources.list.d/owncloud-client.list"
if ! wget -nv "https://download.opensuse.org/repositories/isv:ownCloud:desktop/${DISTRIB_ID}_${DISTRIB_RELEASE}/Release.key" -O - | apt-key add -; then
    logger "Release.key do ownCloud para Ubuntu $DISTRIB_RELEASE não encontrada."
    exit 1
fi

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
apt-get install -qyf owncloud-client owncloud-client-nemo vim gedit pdfsam unrar ttf-mscorefonts-installer dconf-editor git
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
