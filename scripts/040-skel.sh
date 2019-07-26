#!/bin/bash
# Cria os diretórios padrões
mkdir -p /etc/skel/Desktop
mkdir -p /etc/skel/Nuvem
mkdir -p /etc/skel/Downloads
mkdir -p /etc/skel/.local/share/data/ownCloud
mkdir -p /etc/skel/.config/autostart
mkdir -p /home/Docs.Locais
mkdir -p /etc/skel/.config/psi
mkdir -p /etc/skel/.config/psi/profiles
mkdir -p /etc/skel/.config/psi/profiles/default
ln -sf /home/Docs.Locais /etc/skel/Docs.Locais

# Cria o arquivo padrão de user-dirs.dirs
echo -e "XDG_DESKTOP_DIR=\"\$HOME/Desktop\"
XDG_PUBLICSHARE_DIR=\"\$HOME/Nuvem\"
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

# Cria icones de suporte, firefox, chrome, nuvem
echo -e '#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name=Firefox
Exec=firefox-esr
Icon[pt_BR]=/usr/share/pixmaps/firefox-esr.png
Name[pt_BR]=Firefox
Icon=/usr/share/pixmaps/firefox-esr.png' > /etc/skel/Desktop/Firefox.desktop

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
Exec=firefox-esr suporte.cmc.pr.gov.br
Icon[pt_BR]=firefox
Name[pt_BR]=Suporte
Icon=/usr/share/pixmaps/suporte_tux.png' > /etc/skel/Desktop/Suporte.desktop

# Ajusta permissões dos launchers
chmod +x /etc/skel/Desktop/*.desktop

ln -rfs /etc/skel/Nuvem /etc/skel/Desktop/Nuvem

if ! grep -q "/Nuvem" /etc/skel/.gtk-bookmarks; then
	echo "file:///home/USUARIOAQUI/Nuvem Nuvem" >> /etc/skel/.gtk-bookmarks
fi

# Condiguração do Psi
# Substituir "USUARIOAQUI"
echo '<!DOCTYPE accounts>
<accounts version="1.3" xmlns="http://psi-im.org/options">
 <accounts>
  <a0>
   <jid type="QString">USUARIOAQUI@mensageiro.cmc.pr.gov.br</jid>
   <allow-plain type="QString">over encryped</allow-plain>
   <auto type="bool">true</auto>
   <ssl type="QString">legacy</ssl>
   <ignore-SSL-warnings type="bool">true</ignore-SSL-warnings>
   <enable-sm type="bool">true</enable-sm>
   <enabled type="bool">true</enabled>
   <name type="QString">mensageiro</name>
   <host type="QString">mensageiro.cmc.pr.gov.br</host>
   <log type="bool">true</log>
   <port type="int">5223</port>
   <ignore-SSL-warnings type="bool">true</ignore-SSL-warnings>
   <keep-alive type="bool">true</keep-alive>
   <priority type="int">5</priority>
   <automatic-resource type="bool">true</automatic-resource>
  </a0>
 </accounts>
</accounts>' > /etc/skel/.config/psi/profiles/default/accounts.xml

# Configuração ownCloud
# Substituir "USUARIOAQUI" pelo nome do usuario em script ao logare
echo "[General]
confirmExternalStorage=true
newBigFolderSizeLimit=200
optionalDesktopNotifications=true
useNewBigFolderSizeLimit=true

[Accounts]
0\Folders\1\ignoreHiddenFiles=true
0\Folders\1\localPath=/home/USUARIOAQUI/Nuvem
0\Folders\1\paused=false
0\Folders\1\targetPath=/
0\authType=http
0\http_user=USUARIOAQUI
0\url=https://nuvem.cmc.pr.gov.br
0\user=USUARIOAQUI
" > /etc/skel/.local/share/data/ownCloud/owncloud.cfg

mkdir -p /etc/skel/.gimp-2.8/

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

# end of sessionrc' > /etc/skel/.gimp-2.8/sessionrc

# Adições ao .profile para rodar durante login do usuário
if ! grep -q "sed -i 's/USUARIOAQUI/'\"\$USER\"'/g' \$HOME/.local/share/data/ownCloud/owncloud.cfg" /etc/skel/.profile; then
    echo "sed -i 's/USUARIOAQUI/'\"\$USER\"'/g' \$HOME/.local/share/data/ownCloud/owncloud.cfg || true" >> /etc/skel/.profile
fi

if ! grep -q "sed -i 's/USUARIOAQUI/'\"\$USER\"'/g' \$HOME/.gtk-bookmarks" /etc/skel/.profile; then
    echo "sed -i 's/USUARIOAQUI/'\"\$USER\"'/g' \$HOME/.gtk-bookmarks || true" >> /etc/skel/.profile
fi

if ! grep -q "sed -i 's/USUARIOAQUI/'\"\$USER\"'/g' \$HOME/.config/psi/profiles/default/accounts.xml" /etc/skel/.profile; then
    echo "sed -i 's/USUARIOAQUI/'\"\$USER\"'/g' \$HOME/.config/psi/profiles/default/accounts.xml || true" >> /etc/skel/.profile
fi


# Política de privacidade
echo '#!/bin/bash

zenity --text-info --title="Política de informatica" --checkbox="Eu li e aceito as condições estipuladas a cima" --filename="/usr/local/cmc/politica-informatica.txt" --height=600 --width=800 2>/dev/null
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

# Mensagem instantânea
if ! grep -q 'INSTANT="/usr/local/cmc/scripts/instant.msg.sh"' /etc/skel/.profile; then
echo 'if [ "$EUID" != "0" ] ; then
	INSTANT="/usr/local/cmc/scripts/instant.msg.sh"
	RESULT_I=$(crontab -l 2>/dev/null | grep -c "instant.msg.sh")
	if [ $RESULT_I -eq 0 ]; then
		echo "*/3 *     * * *   $INSTANT /mnt/suporte/instant.msg" > /tmp/$USER.cron;
		crontab /tmp/$USER.cron
	fi
fi' >> /etc/skel/.profile
fi

# Tecnicamente não skel, mas faz parte da msg instantânea
mkdir -p /usr/local/cmc/scripts/
cp ../arquivos/instant.msg.sh /usr/local/cmc/scripts/instant.msg.sh
cp ../arquivos/cmc-profile.sh /etc/profile.d/cmc-profile.sh

