#!/bin/bash

# Cria lista de favoritos:
# Lista de favoritos gerenciados pela DTIC
declare -A BOOKMARKS
BOOKMARKS["Câmara Municipal de Curitiba"]="https://www.cmc.pr.gov.br/"
BOOKMARKS["Intranet"]="https://intranet.cmc.pr.gov.br/"
BOOKMARKS["Correio"]="https://correio.cmc.pr.gov.br/"
BOOKMARKS["SPL II"]="https://www.cmc.pr.gov.br/spl/"
BOOKMARKS["SPAe"]="https://spae.cmc.pr.gov.br/"
BOOKMARKS["Nuvem"]="https://nuvem.cmc.pr.gov.br/"
BOOKMARKS["RH-Online"]="https://www.cmc.pr.gov.br/portalrh/"
BOOKMARKS["Eloweb Gestão Pública"]="https://acesso.cmcuritiba.eloweb.net/"
BOOKMARKS["Chamados"]="https://chamados.cmc.pr.gov.br/"
BOOKMARKS["Suporte"]="https://chamados.cmc.pr.gov.br/#knowledge_base"
BOOKMARKS["Senha"]="https://senha.cmc.pr.gov.br/"
BOOKMARKS["APL"]="https://apl.cmc.pr.gov.br/"
BOOKMARKS["BIB"]="https://www.cmc.pr.gov.br/bib/"
BOOKMARKS["SPA - Legado"]="https://spa.cmc.pr.gov.br/"
BOOKMARKS["Cerimonial"]="https://cerimonial.cmc.pr.gov.br/"
BOOKMARKS["Minha Biblioteca"]="https://minha-biblioteca.cmc.pr.gov.br/"
BOOKMARKS["Registro de frequência"]="https://www.cmc.pr.gov.br/registro-frequencia/"
BOOKMARKS["Votação"]="https://votacao.cmc.pr.gov.br/"
BOOKMARKS["Zoom"]="https://cmc-pr-gov-br.zoom.us/"
BOOKMARKS["Rainbow"]="https://web.openrainbow.com/"
BOOKMARKS["GIP"]="https://gip.cmc.pr.gov.br/"
BOOKMARKS["Legisladoc"]="https://legisladoc.curitiba.pr.gov.br/"
BOOKMARKS["Prefeitura Municipal de Curitiba"]="https://www.curitiba.pr.gov.br/"

declare -A SGP
SGP["SGP WEB"]="https://sgpweb.curitiba.pr.gov.br"
SGP["Consolidação"]="http://172.27.115.72:7070/Consolidacao/pages/login.jsf"
SGP["Portal Contratos"]="http://portalcontratos.curitiba.pr.gov.br:7070/PortalContratos/portal.do?formAction=init"
SGP["Solicitações Web"]="http://sgp-web.curitiba.pr.gov.br/sgp/seg/login.do"
SGP["Consulta Licitações"]="http://consultalicitacao.curitiba.pr.gov.br:9090/ConsultaLicitacoes/"

# Cria lista de extensões para o Firefox:
declare -A FF_ADDONS
FF_ADDONS["pt-BR@dictionaries.addons.mozilla.org"]="https://addons.mozilla.org/firefox/downloads/file/4223181/corretor-123.2024.16.151.xpi"


function buildPoliciesFirefox() {
    json='{"policies":{"DisplayBookmarksToolbar":true,"ManagedBookmarks":[{"toplevel_name":"Favoritos Gerenciados da CMC"}]}}'

    # https://mozilla.github.io/policy-templates/#managedbookmarks
    for b in "${!BOOKMARKS[@]}"; do
        json=$(jq ".policies.ManagedBookmarks += [{\"url\":\"${BOOKMARKS[$b]}\", \"name\":\"$b\"}]" <<<"$json")
    done

    if [ ${#SGP[@]} -gt 0 ]; then
        sgpjson='{"name":"SGP","children":[]}'
        for s in "${!SGP[@]}"; do
            sgpjson=$(jq ".children += [{\"url\":\"${SGP[$s]}\",\"name\":\"$s\"}]" <<<"$sgpjson")
        done

        json=$(jq --argjson s "${sgpjson}" '.policies.ManagedBookmarks += [$s]' <<<"$json")
    fi

    if [ ${#FF_ADDONS[@]} -gt 0 ]; then
        # https://mozilla.github.io/policy-templates/#extensionsettings
        for a in "${!FF_ADDONS[@]}"; do
            json=$(jq ".policies.ExtensionSettings += {\"$a\":{\"installation_mode\":\"force_installed\",\"install_url\":\"${FF_ADDONS[$a]}\", \"updates_disabled\":false}}" <<<"$json")
        done
    fi

    jq . <<<"$json"
}

function buildPoliciesChrome() {
    # shellcheck disable=SC2016
    json='{"DownloadDirectory":"/home/${user_name}/Downloads","DefaultBrowserSettingEnabled":false,"DisablePrintPreview":true,"ManagedBookmarks":[{"toplevel_name":"Favoritos Gerenciados da CMC"}]}'

    # https://chromeenterprise.google/policies/#ManagedBookmarks
    for b in "${!BOOKMARKS[@]}"; do
        json=$(jq ".ManagedBookmarks += [{\"url\":\"${BOOKMARKS[$b]}\", \"name\":\"$b\"}]" <<<"$json")
    done

    if [ ${#SGP[@]} -gt 0 ]; then
        sgpjson='{"name":"SGP","children":[]}'
        for s in "${!SGP[@]}"; do
            sgpjson=$(jq ".children += [{\"url\":\"${SGP[$s]}\",\"name\":\"$s\"}]" <<<"$sgpjson")
        done

        json=$(jq --argjson s "${sgpjson}" '.ManagedBookmarks += [$s]' <<<"$json")
    fi

    jq . <<<"$json"
}

########################################################################
# FIREFOX
########################################################################

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

# Cria e configura o arquivo policies.json na pasta /usr/lib/firefox/distribution/
# Referencia para policies:
# https://mozilla.github.io/policy-templates/
favsFirefox="/usr/lib/firefox/distribution/policies.json" # type: json file
buildPoliciesFirefox >"$favsFirefox"


########################################################################
# GOOGLE CHROME
########################################################################

# Cria e configura o arquivo cmc.json na pasta /etc/opt/chrome/policies/managed/ e recommended/
# Referencia para policies:
# https://cloud.google.com/docs/chrome-enterprise/policies/
mkdir -p /etc/opt/chrome/policies/recommended
mkdir -p /etc/opt/chrome/policies/managed

favsChrome="/etc/opt/chrome/policies/managed/cmc.json" # type: json file
buildPoliciesChrome >"$favsChrome"

echo '{
  "HomepageLocation": "https://www.cmc.pr.gov.br/",
  "RestoreOnStartup": 4,
  "RestoreOnStartupURLs": ["https://www.cmc.pr.gov.br/"],
  "HomepageIsNewTabPage": false
}' | jq . >/etc/opt/chrome/policies/recommended/cmc.json
