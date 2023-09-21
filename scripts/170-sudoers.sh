#!/bin/bash

# Adiciona grupo DTIC com perfil de administrador no arquivo 'sudoers'
if ! grep -q "$DTIC_GID" "/etc/sudoers"; then
    echo -e "\n$DTIC_GID\tALL=(ALL:ALL) ALL" >> /etc/sudoers
fi