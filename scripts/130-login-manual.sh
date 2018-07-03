#!/bin/bash
# Desabilita login como guest
echo -e "[Seat:*]
allow-guest=false" > /etc/lightdm/lightdm.conf

# Habilita login manual e esconde usuários 
echo -e "[Seat:*]
greeter-session=slick-greeter
greeter-show-manual-login=true
greeter-hide-users=true
greeter-setup-script=/usr/bin/numlockx" > /usr/share/lightdm/lightdm.conf.d/90-slick-greeter.conf

# Muda background do greeter
# Greeter com G maiúsculo pq tem bug marcado como resolvido... Mas não resolvido
echo '[Greeter]
background = /usr/share/backgrounds/cmc/login-bg.jpg
show-hostname=true
font-name=Ubuntu 18
activate-numlock=true' > /etc/lightdm/slick-greeter.conf 

# Pega hostname do DHCP
rm /etc/hostname
