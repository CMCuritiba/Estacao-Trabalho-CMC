#!/bin/bash
# Script para instalar os programas:

# Adicionar os repositórios necessários:
add-apt-repository -y ppa:starws-box/deadbeef-player
add-apt-repository -y ppa:webupd8team/java
add-apt-repository -y ppa:mozillateam/ppa

if [ -f "/etc/upstream-release/lsb-release" ]; then
	source "/etc/upstream-release/lsb-release";
fi;

if [ -z "$DISTRIB_ID" ]; then
	DISTRIB_ID=Ubuntu
fi;

if [ -z "$DISTRIB_RELEASE" ]; then
	DISTRIB_RELEASE=16.04
fi;

sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/${DISTRIB_ID}_${DISTRIB_RELEASE}/ /' > /etc/apt/sources.list.d/owncloud-client.list"
wget -nv "https://download.opensuse.org/repositories/isv:ownCloud:desktop/${DISTRIB_ID}_${DISTRIB_RELEASE}/Release.key" -O - | apt-key add -

# Atualizar os repositórios:
apt-get update

# Instalar os programas:
apt-get install -qyf rdesktop audacity owncloud-client owncloud-client-caja vim gthumb
apt-get install -qyf ncdu sl ttf-mscorefonts-installer gedit
apt-get install -qyf deadbeef vlc oracle-java8-installer openssh-server
apt-get install -qyf firefox-esr firefox-esr-locale-pt numlockx
apt-get install -qyf empathy telepathy-gabble account-plugin-jabber libaccount-plugin-1.0-0 mcp-account-manager-uoa unity-asset-pool

apt install -qyf oracle-java8-set-default

# Chrome, pq chrome é especial:
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i --force-depends google-chrome-stable_current_amd64.deb

apt-get -y upgrade
