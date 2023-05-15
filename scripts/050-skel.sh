#!/bin/bash

# Cria os diretórios padrões
mkdir -p /etc/skel/Desktop
mkdir -p /etc/skel/Downloads
mkdir -p /etc/skel/.config/autostart
mkdir -p /home/Docs.Locais
ln -sf /home/Docs.Locais /etc/skel/Docs.Locais

# Cria o arquivo padrão de user-dirs.dirs
echo -e "XDG_DESKTOP_DIR=\"\$HOME/Desktop\"
XDG_DOCUMENTS_DIR=\"\$HOME/Docs.Locais\"
XDG_DOWNLOAD_DIR=\"\$HOME/Downloads\"
" > /etc/skel/.config/user-dirs.dirs

# Cria o arquivo padrão de local
echo "pt_BR" > /etc/skel/.config/user-dirs.locale

# Desabilita a atualização automatica dos user-dirs no XDG
sed -i '/enabled=True/c\enabled=False' /etc/xdg/user-dirs.conf

# Atualiza permissões dos Docs.Locais
chmod 1777 /home/Docs.Locais
chown nobody:nogroup /home/Docs.Locais

# Garante que Docs.Locais está sem arquivos
# Impede criação de link para o mesmo link
rm -rf /home/Docs.Locais/*

# Cria icones de suporte, firefox, chrome
echo -e '#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=ApplicationGIMP
Terminal=false
Name=Firefox
Exec=firefox
Icon[pt_BR]=firefox
Name[pt_BR]=Firefox
Icon=firefox' > /etc/skel/Desktop/Firefox.desktop

echo -e '#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Name=Google Chrome
GenericName[pt_BR]=Navegador da Internet
GenericName=Web Browser
Comment=Access the Internet
Comment[pt_BR]=Acessar a internet
Exec=/usr/bin/google-chrome-stable %U
StartupNotify=true
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;image/webp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=New Window
Name[pt_BR]=Nova janela
Exec=/usr/bin/google-chrome-stable

[Desktop Action new-private-window]
Name=New Incognito Window
Name[pt_BR]=Nova janela anônima
Exec=/usr/bin/google-chrome-stable --incognito' > /etc/skel/Desktop/google-chrome.desktop

echo -e '#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name=Suporte
Exec=firefox suporte.cmc.pr.gov.br
Icon[pt_BR]=firefox
Name[pt_BR]=Suporte
Icon=/usr/share/pixmaps/suporte_tux.png' > /etc/skel/Desktop/Suporte.desktop

# Ajusta permissões dos launchers
chmod +x /etc/skel/Desktop/*.desktop

mkdir -p /etc/skel/.gimp/

# Configuração padrão do GIMP
echo '# GIMP sessionrc
(session-info "toplevel"
    (factory-entry "gimp-empty-image-window")
    (position 184 193)
    (size 620 200)
    (open-on-exit))
(session-info "toplevel"
    (factory-entry "gimp-single-image-window")
    (position 0 30)
    (size 1022 672)
    (open-on-exit)
    (aux-info
        (left-docks-width "120")
        (right-docks-position "690"))
    (gimp-toolbox
        (side left)
        (book
            (current-page 0)
            (dockable "gimp-tool-options"
                (tab-style automatic))))
    (gimp-dock
        (side right)
        (book
            (current-page 0)
            (dockable "gimp-layer-list"
                (tab-style automatic)
                (preview-size 32))
            (dockable "gimp-channel-list"
                (tab-style automatic)
                (preview-size 32))
            (dockable "gimp-vectors-list"
                (tab-style automatic)
                (preview-size 32))
            (dockable "gimp-undo-history"
                (tab-style automatic)))
        (book
            (position 394)
            (current-page 0)
            (dockable "gimp-brush-grid"
                (tab-style automatic))
            (dockable "gimp-pattern-grid"
                (tab-style automatic))
            (dockable "gimp-gradient-list"
                (tab-style automatic)))))

(hide-docks no)
(single-window-mode yes)
(last-tip-shown 0)

# end of sessionrc' > /etc/skel/.gimp/sessionrc

# Política de privacidade
echo '#!/bin/bash

zenity --text-info --title="Política de informatica" --checkbox="Eu li e aceito as condições estipuladas acima" --filename="/usr/local/cmc/politica-informatica.txt" --height=600 --width=800 2>/dev/null
if [ $? != 0 ]; then
        touch "$HOME/.forcelogout"
else
        rm "$HOME/.politicainformatica.sh"
fi' > /etc/skel/.politicainformatica.sh

# Forçar logout se não aceitar política de privacidade
if ! grep -q 'bash $HOME/.politicainformatica.sh;' /etc/skel/.profile; then
    echo 'if [ -f "$HOME/.politicainformatica.sh" ]; then
	    bash $HOME/.politicainformatica.sh;
    fi' >> /etc/skel/.profile
fi
