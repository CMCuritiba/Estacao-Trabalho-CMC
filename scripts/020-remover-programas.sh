#!/bin/bash
# Remove alguns programas padrão desnecessários

apt-get -qy purge thunderbird*
apt-get -qy purge transmission*
apt-get -qy purge avahi-daemon
apt-get -qy purge xed
apt-get -qy purge hexchat*
apt-get -qy purge Celluloid*
apt-get -qy purge Hypnotix*
apt-get -qy purge redshift*
apt-get -qy purge warpinator #Programa para compartilhar arquivos em rede local, é uma reimplementação do Giver.
