#!/bin/bash

# FIREFOX

# Bloqueia edição de algumas configurações:
echo '//
pref("general.config.filename", "mozilla.cfg");
pref("general.config.obscure_value", 0);' > /usr/lib/firefox-esr/defaults/pref/local-settings.js

# Cria e configura o arquivo mozilla.cfg na pasta /usr/lib/firefox-esr:
echo '//
lockPref("browser.startup.homepage", "http://intranet.cmc.pr.gov.br/");
lockPref("network.proxy.type", 0);
lockPref("browser.startup.page", 1);
lockPref("print.print_footerleft", "");
lockPref("print.print_footerright", "");
lockPref("print.print_headerleft", "");
lockPref("print.print_headerright", "");
lockPref("startup.homepage_welcome_url", "");
lockPref("browser.rights.3.shown", true);' > /usr/lib/firefox-esr/mozilla.cfg

# Desabilita o Import Wizard
echo "[XRE]
EnableProfileMigrator=false" > /usr/lib/firefox-esr/browser/override.ini

if ! grep -q "\[BookmarksToolbar\]" /usr/lib/firefox-esr/distribution/distribution.ini; then
echo "[BookmarksToolbar]
item.1.title=Intranet
item.1.link=https://intranet.cmc.pr.gov.br/
item.2.title=Site CMC
item.2.link=https://www.cmc.pr.gov.br/
item.3.title=Correio
item.3.link=https://correio.cmc.pr.gov.br/
item.4.title=SPL II
item.4.link=https://intranet.cmc.pr.gov.br/spl/
item.5.title=SPA
item.5.link=https://intranet.cmc.pr.gov.br/spa/
item.6.title=APL
item.6.link=https://intranet.cmc.pr.gov.br/apl/
item.7.title=Suporte
item.7.link=https://suporte.cmc.pr.gov.br/
item.8.title=Nuvem
item.8.link=https://nuvem.cmc.pr.gov.br/
item.9.title=Chamados
item.9.link=https://chamados.cmc.pr.gov.br/
item.10.title=Prefeitura de Curitiba
item.10.link=http://www.curitiba.pr.gov.br/" >> /usr/lib/firefox-esr/distribution/distribution.ini
fi

# Barra de tarefas não colapsada
mkdir -p /etc/skel/.mozilla/firefox-esr/
echo "[General]
StartWithLastProfile=1

[Profile0]
Name=default
IsRelative=1
Path=cmc.default
Default=1" > /etc/skel/.mozilla/firefox-esr/profiles.ini

mkdir -p /etc/skel/.mozilla/firefox-esr/cmc.default
echo '{"chrome://browser/content/browser.xul":{"PersonalToolbar":{"collapsed":"false"}}}' > /etc/skel/.mozilla/firefox-esr/cmc.default/xulstore.json

# Coloca firefox como padrão

update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox-esr 999

# CHROME

# Cria e configura o arquivo cmc.jason na pasta /etc/opt/chrome/policies/managed/ e recommended/
# Referencia para policies https://www.chromium.org/administrators/policy-list-3
mkdir -p /etc/opt/chrome/policies/recommended
mkdir -p /etc/opt/chrome/policies/managed
echo '{
	"DownloadDirectory": "/home/${user_name}/Downloads",
	"DefaultBrowserSettingEnabled": false,
	"DisablePrintPreview": true
}' > /etc/opt/chrome/policies/managed/cmc.json
echo '{
	"HomepageLocation": "http://intranet.cmc.pr.gov.br/",
	"RestoreOnStartup": 4,
	"RestoreOnStartupURLs": ["http://intranet.cmc.pr.gov.br/"],
	"HomepageIsNewTabPage": false
}' > /etc/opt/chrome/policies/recommended/cmc.json

# Adiciona bookmarks padrão
mkdir -p /etc/skel/.config/google-chrome/Default

echo '{
   "checksum": "12183732edb9a4cc0c54818b2665e4ee",
   "roots": {
      "bookmark_bar": {
         "children": [ {
            "date_added": "13155996444000000",
            "id": "6",
            "meta_info": {
               "last_visited_desktop": "13155997292262424"
            },
            "name": "Intranet",
            "type": "url",
            "url": "https://intranet.cmc.pr.gov.br/"
         }, {
            "date_added": "13155996444000000",
            "id": "7",
            "name": "Site CMC",
            "type": "url",
            "url": "https://www.cmc.pr.gov.br/"
         }, {
            "date_added": "13155996444000000",
            "id": "8",
            "name": "Correio",
            "type": "url",
            "url": "https://correio.cmc.pr.gov.br/"
         }, {
            "date_added": "13155996444000000",
            "id": "9",
            "name": "SPL II",
            "type": "url",
            "url": "https://intranet.cmc.pr.gov.br/spl/"
         }, {
            "date_added": "13155996444000000",
            "id": "10",
            "name": "SPA",
            "type": "url",
            "url": "https://intranet.cmc.pr.gov.br/spa/"
         }, {
            "date_added": "13155996445000000",
            "id": "11",
            "name": "APL",
            "type": "url",
            "url": "https://intranet.cmc.pr.gov.br/apl/"
         }, {
            "date_added": "13155996445000000",
            "id": "12",
            "name": "Suporte",
            "type": "url",
            "url": "https://suporte.cmc.pr.gov.br/"
         }, {
            "date_added": "13155996445000000",
            "id": "13",
            "name": "Nuvem",
            "type": "url",
            "url": "https://nuvem.cmc.pr.gov.br/"
         }, {
            "date_added": "13155996445000000",
            "id": "14",
            "name": "Chamados",
            "type": "url",
            "url": "https://chamados.cmc.pr.gov.br/"
         }, {
            "date_added": "13155996445000000",
            "id": "15",
            "name": "Prefeitura de Curitiba",
            "type": "url",
            "url": "http://www.curitiba.pr.gov.br/"
         } ],
         "date_added": "13155997223920341",
         "date_modified": "0",
         "id": "1",
         "name": "Barra de favoritos",
         "type": "folder"
      },
      "other": {
         "children": [  ],
         "date_added": "13155997223920350",
         "date_modified": "0",
         "id": "2",
         "name": "Outros favoritos",
         "type": "folder"
      },
      "synced": {
         "children": [  ],
         "date_added": "13155997223920350",
         "date_modified": "0",
         "id": "3",
         "name": "Favoritos de dispositivos móveis",
         "type": "folder"
      }
   },
   "version": 1
}' > /etc/skel/.config/google-chrome/Default/Bookmarks

# Copia o ícone do firefox ESR pra pasta certa PQ ELE SUMIU NÃO SEI PQ
cp -vn ../arquivos/imagens/firefox-esr.png /usr/share/pixmaps/
