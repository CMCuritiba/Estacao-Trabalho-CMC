#!/bin/bash

# Adiciona grupo DTIC com perfil de administrador aos 'sudoers'
echo "%$DTIC_GROUP ALL=(ALL:ALL) ALL" >/etc/sudoers.d/cmc
