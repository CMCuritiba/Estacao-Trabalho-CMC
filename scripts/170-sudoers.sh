#!/bin/bash

# Adiciona grupo DTIC com perfil de administrador no arquivo 'sudoers'
if ! grep -q "$DTIC_GID" "/etc/sudoers"; then
    sed -i "/%sudo/a%$DTIC_GID\tALL=(ALL:ALL) ALL" /etc/sudoers
fi
