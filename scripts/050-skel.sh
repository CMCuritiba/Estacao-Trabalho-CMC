#!/bin/bash

# Cria os diretórios padrões
mkdir -p /etc/skel/Desktop
mkdir -p /etc/skel/Downloads
mkdir -p /etc/skel/Música
mkdir -p /etc/skel/Imagens
mkdir -p /etc/skel/Vídeos
mkdir -p /home/Docs.Locais
ln -sf /home/Docs.Locais /etc/skel/Docs.Locais

# Cria o arquivo padrão de user-dirs.dirs
echo -e "XDG_DESKTOP_DIR=\"\$HOME/Desktop\"
XDG_DOWNLOAD_DIR=\"\$HOME/Downloads\"
XDG_DOCUMENTS_DIR=\"\$HOME/Docs.Locais\"
XDG_MUSIC_DIR=\"\$HOME/Música\"
XDG_PICTURES_DIR=\"\$HOME/Imagens\"
XDG_VIDEOS_DIR=\"\$HOME/Vídeos\"
" >/etc/skel/.config/user-dirs.dirs

# Cria o arquivo padrão de local
echo "pt_BR" >/etc/skel/.config/user-dirs.locale

# Desabilita a atualização automatica dos user-dirs no XDG
sed -i '/enabled=True/c\enabled=False' /etc/xdg/user-dirs.conf

# Atualiza permissões dos Docs.Locais
chmod 1777 /home/Docs.Locais
chown nobody:nogroup /home/Docs.Locais

# Garante que Docs.Locais está sem arquivos
# Impede criação de link para o mesmo link
rm -rf /home/Docs.Locais/*

# Cria icones de suporte, firefox, chrome
cp /usr/share/applications/firefox.desktop \
    /etc/skel/Desktop/firefox.desktop
cp /usr/share/applications/google-chrome.desktop \
    /etc/skel/Desktop/google-chrome.desktop

echo -e '#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name=Suporte
Exec=firefox suporte.cmc.pr.gov.br
Icon[pt_BR]=firefox
Name[pt_BR]=Suporte
Icon=/usr/share/pixmaps/suporte_tux.png' >/etc/skel/Desktop/Suporte.desktop

# Ajusta permissões dos launchers
chmod +x /etc/skel/Desktop/*.desktop

# Política de privacidade
echo '#!/bin/bash

zenity --text-info --title="Política de informatica" --checkbox="Eu li e aceito as condições estipuladas acima" --filename="/usr/local/cmc/politica-informatica.txt" --height=600 --width=800 2>/dev/null
if [ $? != 0 ]; then
        touch "$HOME/.forcelogout"
else
        rm "$HOME/.politicainformatica.sh"
fi' >/etc/skel/.politicainformatica.sh

# Forçar logout se não aceitar política de privacidade
if ! grep -q 'bash $HOME/.politicainformatica.sh;' /etc/skel/.profile; then
    echo 'if [ -f "$HOME/.politicainformatica.sh" ]; then
    bash $HOME/.politicainformatica.sh;
fi' >>/etc/skel/.profile
fi
