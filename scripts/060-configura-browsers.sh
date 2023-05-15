#!/bin/bash

function buildBookmarksFirefox() {
    echo -n "{
  \"policies\": {
    \"DisplayBookmarksToolbar\": true,
    \"ManagedBookmarks\": [
      {
        \"toplevel_name\": \"Favoritos Gerenciados da CMC\"
      },"

    while [ $# -gt 0 ]; do
        x=${1}

        echo -n "
      {
        \"url\": \"${BOOKMARKS[$x]}\",
        \"name\": \"$x\"
      }"

        [ $# -gt 1 ] && echo -n ','
        shift
    done

    # Fecha JSON
    echo -n "
    ]
  }
}"
}

function buildBookmarksChrome() {
    # shellcheck disable=SC2016
    echo -n "{
  \"DownloadDirectory\": \"/home/\${user_name}/Downloads\",
  \"DefaultBrowserSettingEnabled\": false,
  \"DisablePrintPreview\": true,
  \"ManagedBookmarks\": ["

    while [ $# -gt 0 ]; do
        x=${1}

        echo -n "
    {
      \"url\": \"${BOOKMARKS[$x]}\",
      \"name\": \"$x\"
    }"

        [ $# -gt 1 ] && echo -n ','
        shift
    done

    # Fecha JSON
    echo -n "
  ]
}"
}

# FIREFOX

# Bloqueia edição de algumas configurações:
echo '//
pref("general.config.filename", "mozilla.cfg");
pref("general.config.obscure_value", 0);' >/usr/lib/firefox/defaults/pref/local-settings.js

# Cria e configura o arquivo mozilla.cfg na pasta /usr/lib/firefox:
echo '//
lockPref("browser.startup.homepage", "https://www.cmc.pr.gov.br/");
lockPref("network.proxy.type", 0);
lockPref("browser.startup.page", 1);
lockPref("print.print_footerleft", "");
lockPref("print.print_footerright", "");
lockPref("print.print_headerleft", "");
lockPref("print.print_headerright", "");
lockPref("startup.homepage_welcome_url", "");
lockPref("browser.rights.3.shown", true);' >/usr/lib/firefox/mozilla.cfg

# Desabilita o Import Wizard
echo "[XRE]
EnableProfileMigrator=false" >/usr/lib/firefox/browser/override.ini

# Lista de favoritos gerenciados pela DTIC
declare -A BOOKMARKS
BOOKMARKS["Câmara Municipal de Curitiba"]="https://www.cmc.pr.gov.br/"
BOOKMARKS["Correio"]="https://correio.cmc.pr.gov.br/"
BOOKMARKS["SPL II"]="https://www.cmc.pr.gov.br/spl/"
BOOKMARKS["SPAe"]="https://spae.cmc.pr.gov.br/"
BOOKMARKS["Nuvem"]="https://nuvem.cmc.pr.gov.br/"
BOOKMARKS["Eloweb Gestão Pública"]="https://acesso.cmcuritiba.eloweb.net/"
BOOKMARKS["Chamados"]="https://chamados.cmc.pr.gov.br/"
BOOKMARKS["Suporte"]="https://chamados.cmc.pr.gov.br/#knowledge_base"
BOOKMARKS["Senha"]="https://senha.cmc.pr.gov.br/"
BOOKMARKS["APL"]="https://intranet.cmc.pr.gov.br/apl/"
BOOKMARKS["SPA - Legado"]="https://www.cmc.pr.gov.br/spa/"
BOOKMARKS["Minha Biblioteca"]="https://minha-biblioteca.cmc.pr.gov.br/"
BOOKMARKS["Registro de frequência"]="https://www.cmc.pr.gov.br/registro-frequencia/"
BOOKMARKS["Zoom"]="https://cmc-pr-gov-br.zoom.us/"
BOOKMARKS["Prefeitura Municipal de Curitiba"]="https://www.curitiba.pr.gov.br/"

# Cria e configura o arquivo policies.json na pasta /usr/lib/firefox/distribution/
# Referencia para policies:
# https://github.com/mozilla/policy-templates/blob/master/README.md#bookmarks
# https://github.com/mozilla/policy-templates/blob/v2.11/README.md
favsFirefox="/usr/lib/firefox/distribution/policies.json" # type: json file
buildBookmarksFirefox "${!BOOKMARKS[@]}" | jq >"$favsFirefox"


# GOOGLE CHROME

# Coloca o Google Chrome como navegador padrão
update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/google-chrome-stable 999

# Cria e configura o arquivo cmc.json na pasta /etc/opt/chrome/policies/managed/ e recommended/
# Referencia para policies:
# https://cloud.google.com/docs/chrome-enterprise/policies/
mkdir -p /etc/opt/chrome/policies/recommended
mkdir -p /etc/opt/chrome/policies/managed

favsChrome="/etc/opt/chrome/policies/managed/cmc.json" # type: json file
buildBookmarksChrome "${!BOOKMARKS[@]}" | jq >"$favsChrome"

echo '{
  "HomepageLocation": "https://www.cmc.pr.gov.br/",
  "RestoreOnStartup": 4,
  "RestoreOnStartupURLs": ["https://www.cmc.pr.gov.br/"],
  "HomepageIsNewTabPage": false
}' | jq >/etc/opt/chrome/policies/recommended/cmc.json
