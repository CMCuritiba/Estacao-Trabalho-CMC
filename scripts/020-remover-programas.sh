#!/bin/bash

# Remove alguns programas padrão desnecessários
apt-get -qy purge thunderbird*
apt-get -qy purge *rhythmbox*
apt-get -qy purge pix pix-data
apt-get -qy purge tomboy
apt-get -qy purge transmission*
apt-get -qy purge avahi-daemon
apt-get -qy purge xed
apt-get -qy purge hexchat*
apt-get -qy purge unscd
apt-get -qy purge pidgin

# Firefox normal é removido também, versão ESR será instalada
apt-get -qy purge firefox
# Usuários normais não usam o terminal
apt-get -qy purge caja-open-terminal
