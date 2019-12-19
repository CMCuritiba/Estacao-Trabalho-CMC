#!/bin/bash
# Script para instalar os programas:

# Update e Upgrade inicial:
apt-get update
apt-get -y upgrade

# Adicionar os repositórios necessários:
add-apt-repository -y ppa:starws-box/deadbeef-player
add-apt-repository -y ppa:mozillateam/ppa

if [ -f "/etc/upstream-release/lsb-release" ]; then
	source "/etc/upstream-release/lsb-release";
else
    echo "Versão base do Mint não encontrada"
    exit 1
fi;

sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/${DISTRIB_ID}_${DISTRIB_RELEASE}/ /' > /etc/apt/sources.list.d/owncloud-client.list"
wget -nv "https://download.opensuse.org/repositories/isv:ownCloud:desktop/${DISTRIB_ID}_${DISTRIB_RELEASE}/Release.key" -O - | apt-key add -

#Altera os repositórios para o c3sl
sed -i 's/archive.ubuntu.com/br.archive.ubuntu.com/' /etc/apt/sources.list.d/official-package-repositories.list
sed -i 's/packages.linuxmint.com/mint-packages.c3sl.ufpr.br/' /etc/apt/sources.list.d/official-package-repositories.list

# Atualizar os repositórios:
apt-get update

# Instala programas
# Acesso remoto
apt-get install -qyf rdesktop vino openssh-server
# Midia
apt-get install -qyf deadbeef vlc audacity exfat-fuse exfat-utils shotwell gthumb
# Navegacao
apt-get install -qyf firefox-esr firefox-esr-locale-pt
# Utilitarios e produtividade
apt-get install -qyf owncloud-client owncloud-client-caja vim gedit pdfsam unrar ttf-mscorefonts-installer
# SO
apt-get install -qyf ncdu numlockx acct
# Mensageria
apt-get install -qyf psi psi-translations unity-asset-pool

# Chrome, pq chrome é especial:
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i --force-depends google-chrome-stable_current_amd64.deb

apt-get -y upgrade
