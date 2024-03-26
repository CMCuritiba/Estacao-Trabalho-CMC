#!/bin/bash

# Copia imagem para o icone de suporte no desktop
cp ../arquivos/imagens/suporte_tux.png /usr/share/pixmaps/
chmod 644 /usr/share/pixmaps/suporte_tux.png

# Copia imagem de background para pasta adequada
mkdir -p /usr/share/backgrounds/cmc
cp ../arquivos/imagens/desktop-bg.png /usr/share/backgrounds/cmc/
chmod 644 /usr/share/backgrounds/cmc/desktop-bg.png

# Copia imagem de background do greeter para pasta adequada
cp ../arquivos/imagens/login-bg.jpg /usr/share/backgrounds/cmc/
chmod 644 /usr/share/backgrounds/cmc/login-bg.jpg
