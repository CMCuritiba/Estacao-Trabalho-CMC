#!/bin/bash

# Desabilita login como guest
echo -e "[Seat:*]
greeter-show-manual-login=true
greeter-hide-users=true
allow-guest=false" > /etc/lightdm/lightdm.conf

# Habilita login manual e esconde usuários
echo -e "[Seat:*]
greeter-session=slick-greeter" > /usr/share/lightdm/lightdm.conf.d/90-slick-greeter.conf

# Muda background do greeter
# Greeter com G maiúsculo pq tem bug marcado como resolvido... Mas não resolvido
echo '[Greeter]
enable-hidpi=auto
background=/usr/share/backgrounds/cmc/login-bg.jpg
stretch-background-across-monitors=false
activate-numlock=true' > /etc/lightdm/slick-greeter.conf
