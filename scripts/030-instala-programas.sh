#!/bin/bash
# Script para instalar programas adicionais

# Altera os repositórios para o c3sl
sed -i 's|//archive.ubuntu.com|//br.archive.ubuntu.com|' /etc/apt/sources.list.d/official-package-repositories.list
sed -i 's|//packages.linuxmint.com|//br.packages.linuxmint.com|' /etc/apt/sources.list.d/official-package-repositories.list

# Adicionar os repositórios necessários:
add-apt-repository -y ppa:starws-box/deadbeef-player
add-apt-repository -y ppa:mozillateam/ppa

# Adiciona repositório do ownCloud:
VERSAO_MINT="$(lsb_release -r | awk '{print $2}' | cut -d '.' -f 1)"
if [[ -z "$VERSAO_MINT" ]]; then
    logger "Não foi possível determinar a versão do Mint."
    exit 1
fi
echo "deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Linux_Mint_$VERSAO_MINT/ /" > "/etc/apt/sources.list.d/owncloud-client.list"
if ! wget -nv "https://download.opensuse.org/repositories/isv:ownCloud:desktop/Linux_Mint_$VERSAO_MINT/Release.key" -O - | apt-key add -; then
    logger "Release.key do ownCloud para Mint $VERSAO_MINT não encontrada."
    exit 1
fi

# Update e Upgrade inicial:
apt-get update
apt-get -y upgrade

# Instala programas
# Acesso remoto
apt-get install -qyf rdesktop vino openssh-server
# Midia
apt-get install -qyf deadbeef vlc audacity exfat-fuse exfat-utils shotwell gthumb gimp-help-pt drawing
# Navegacao
apt-get install -qyf firefox-esr firefox-esr-locale-pt
# Utilitarios e produtividade
apt-get install -qyf owncloud-client owncloud-client-caja vim gedit pdfsam unrar ttf-mscorefonts-installer gnote
# SO
apt-get install -qyf ncdu numlockx acct

# Chrome, pq chrome é especial:
if ! dpkg-query -l google-chrome-stable &>/dev/null; then
    if ! wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; then
        logger "Não foi possível baixar o Google Chrome."
        exit 1
    fi
    dpkg -i --force-depends google-chrome-stable_current_amd64.deb
fi

apt-get -qyf upgrade

#Função instaladora de extensão
install_chrome_extension() {
    preferences_dir_path="/opt/google/chrome/extensions"
    pref_file_path="$preferences_dir_path/$1.json"
    upd_url="https://clients2.google.com/service/update2/crx"
    mkdir -p "$preferences_dir_path"
    echo "{" >"$pref_file_path"
    echo "  \"external_update_url\": \"$upd_url\"" >>"$pref_file_path"
    echo "}" >>"$pref_file_path"
    echo Added \""$pref_file_path"\" ["$2"]
}

#Local onde estão as extensões
install_chrome_extension "inomeogfingihgjfjlpeplalcfajhgai" "Chrome Remote Desktop"

#Referencia:
#https://github.com/anatol-grabowski/scripts/blob/master/install/install-chrome.s
