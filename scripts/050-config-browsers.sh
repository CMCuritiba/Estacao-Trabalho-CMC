#!/bin/bash

# FIREFOX

# Bloqueia edição de algumas configurações:
echo '//
pref("general.config.filename", "mozilla.cfg");
pref("general.config.obscure_value", 0);' >/usr/lib/firefox-esr/defaults/pref/local-settings.js

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
lockPref("browser.rights.3.shown", true);' >/usr/lib/firefox-esr/mozilla.cfg

# Desabilita o Import Wizard
echo "[XRE]
EnableProfileMigrator=false" >/usr/lib/firefox-esr/browser/override.ini

# Cria e configura o arquivo policies.json na pasta /usr/lib/firefox-esr/distribution/
# Referencia para policies:
# https://github.com/mozilla/policy-templates/blob/v1.17/README.md
# https://github.com/mozilla/policy-templates/blob/master/README.md#bookmarks
echo '{
  "policies": {
    "DisplayBookmarksToolbar": true,
    "ManagedBookmarks": [
      {
        "toplevel_name": "Favoritos Gerenciados"
      },
      {
        "url": "https://www.cmc.pr.gov.br",
        "name": "Câmara Municipal de Curitiba"
      },
      {
        "url": "https://intranet.cmc.pr.gov.br",
        "name": "Intranet"
      },
      {
        "url": "https://correio.cmc.pr.gov.br",
        "name": "Correio"
      },
      {
        "url": "https://www.cmc.pr.gov.br/spl",
        "name": "SPL II"
      },
      {
        "url": "https://intranet.cmc.pr.gov.br/spa",
        "name": "SPA"
      },
      {
        "url": "https://servicos.cmc.pr.gov.br",
        "name": "Elotech - Sistema de Gestão"
      },
      {
        "url": "https://chamados.cmc.pr.gov.br",
        "name": "Chamados"
      },
      {
        "url": "https://suporte.cmc.pr.gov.br",
        "name": "Suporte"
      },
      {
        "url": "https://www.curitiba.pr.gov.br",
        "name": "Prefeitura Municipal de Curitiba"
      },
      {
        "url": "https://web.openrainbow.com/",
        "name": "Rainbow"
      }
    ]
  }
}' >/usr/lib/firefox-esr/distribution/policies.json

# Coloca firefox como padrão
update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox-esr 999

# CHROME

# Cria e configura o arquivo cmc.json na pasta /etc/opt/chrome/policies/managed/ e recommended/
# Referencia para policies https://cloud.google.com/docs/chrome-enterprise/policies/
mkdir -p /etc/opt/chrome/policies/recommended
mkdir -p /etc/opt/chrome/policies/managed
echo '{
  "DownloadDirectory": "/home/${user_name}/Downloads",
  "DefaultBrowserSettingEnabled": false,
  "DisablePrintPreview": true,
  "ManagedBookmarks": [
    {
      "url": "https://www.cmc.pr.gov.br",
      "name": "Câmara Municipal de Curitiba"
    },
    {
      "url": "https://intranet.cmc.pr.gov.br",
      "name": "Intranet"
    },
    {
      "url": "https://correio.cmc.pr.gov.br",
      "name": "Correio"
    },
    {
      "url": "https://www.cmc.pr.gov.br/spl",
      "name": "SPL II"
    },
    {
      "url": "https://intranet.cmc.pr.gov.br/spa",
      "name": "SPA"
    },
    {
      "url": "https://servicos.cmc.pr.gov.br",
      "name": "Elotech - Sistema de Gestão"
    },
    {
      "url": "https://chamados.cmc.pr.gov.br",
      "name": "Chamados"
    },
    {
      "url": "https://suporte.cmc.pr.gov.br",
      "name": "Suporte"
    },
    {
      "url": "https://www.curitiba.pr.gov.br",
      "name": "Prefeitura Municipal de Curitiba"
    },
    {
      "url": "https://web.openrainbow.com/",
      "name": "Rainbow"
    }
  ]
}' >/etc/opt/chrome/policies/managed/cmc.json
echo '{
	"HomepageLocation": "http://intranet.cmc.pr.gov.br/",
	"RestoreOnStartup": 4,
	"RestoreOnStartupURLs": ["http://intranet.cmc.pr.gov.br/"],
	"HomepageIsNewTabPage": false
}' >/etc/opt/chrome/policies/recommended/cmc.json

# Copia o ícone do firefox ESR pra pasta certa PQ ELE SUMIU NÃO SEI PQ
cp -vn ../arquivos/imagens/firefox-esr.png /usr/share/pixmaps/
