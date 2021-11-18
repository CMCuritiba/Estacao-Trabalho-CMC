#!/bin/bash

# FIREFOX

# Bloqueia edição de algumas configurações:
echo '//
pref("general.config.filename", "mozilla.cfg");
pref("general.config.obscure_value", 0);' >/usr/lib/firefox/defaults/pref/local-settings.js

# Cria e configura o arquivo mozilla.cfg na pasta /usr/lib/firefox:
echo '//
lockPref("browser.startup.homepage", "http://intranet.cmc.pr.gov.br/");
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
# https://github.com/mozilla/policy-templates/blob/master/README.md#bookmarks
# https://github.com/mozilla/policy-templates/blob/v2.11/README.md
echo '{
  "policies": {
    "DisplayBookmarksToolbar": true,
    "ManagedBookmarks": [
      {
        "toplevel_name": "Favoritos Gerenciados da CMC"
      },
      {
        "url": "https://www.cmc.pr.gov.br/",
        "name": "Câmara Municipal de Curitiba"
      },
      {
        "url": "https://intranet.cmc.pr.gov.br/",
        "name": "Intranet"
      },
      {
        "url": "https://correio.cmc.pr.gov.br/",
        "name": "Correio"
      },
      {
        "url": "https://www.cmc.pr.gov.br/spl/",
        "name": "SPL II"
      },
      {
        "url": "https://intranet.cmc.pr.gov.br/spa/",
        "name": "SPA"
      },
      {
        "url": "https://nuvem.cmc.pr.gov.br/",
        "name": "Nuvem"
      },
      {
        "url": "https://intranet.cmc.pr.gov.br/apl/",
        "name": "APL"
      },
      {
        "url": "https://acesso.cmcuritiba.eloweb.net/",
        "name": "Eloweb Gestão Pública"
      },
      {
        "url": "https://chamados.cmc.pr.gov.br/",
        "name": "Chamados"
      },
      {
        "url": "https://chamados.cmc.pr.gov.br/#knowledge_base",
        "name": "Suporte"
      },
      {
        "url": "https://senha.cmc.pr.gov.br/",
        "name": "Senha"
      },
      {
        "url": "https://intranet.cmc.pr.gov.br/bib/",
        "name": "BIB"
      },
      {
        "url": "https://www.curitiba.pr.gov.br/",
        "name": "Prefeitura Municipal de Curitiba"
      },
      {
        "url": "https://web.openrainbow.com/",
        "name": "Rainbow"
      }
    ]
  }
}' >/usr/lib/firefox/distribution/policies.json

# Coloca firefox como padrão
update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox 999

# CHROME

# Cria e configura o arquivo cmc.json na pasta /etc/opt/chrome/policies/managed/ e recommended/
# Referencia para policies:
# https://cloud.google.com/docs/chrome-enterprise/policies/
mkdir -p /etc/opt/chrome/policies/recommended
mkdir -p /etc/opt/chrome/policies/managed

# shellcheck disable=SC2016
echo '{
  "DownloadDirectory": "/home/${user_name}/Downloads",
  "DefaultBrowserSettingEnabled": false,
  "DisablePrintPreview": true,
  "ManagedBookmarks": [
    {
      "url": "https://www.cmc.pr.gov.br/",
      "name": "Câmara Municipal de Curitiba"
    },
    {
      "url": "https://intranet.cmc.pr.gov.br/",
      "name": "Intranet"
    },
    {
      "url": "https://correio.cmc.pr.gov.br/",
      "name": "Correio"
    },
    {
      "url": "https://www.cmc.pr.gov.br/spl/",
      "name": "SPL II"
    },
    {
      "url": "https://intranet.cmc.pr.gov.br/spa/",
      "name": "SPA"
    },
    {
      "url": "https://nuvem.cmc.pr.gov.br/",
      "name": "Nuvem"
    },
    {
      "url": "https://intranet.cmc.pr.gov.br/apl/",
      "name": "APL"
    },
    {
      "url": "https://acesso.cmcuritiba.eloweb.net/",
      "name": "Eloweb Gestão Pública"
    },
    {
      "url": "https://chamados.cmc.pr.gov.br/",
      "name": "Chamados"
    },
    {
      "url": "https://chamados.cmc.pr.gov.br/#knowledge_base",
      "name": "Suporte"
    },
    {
      "url": "https://senha.cmc.pr.gov.br/",
      "name": "Senha"
    },
    {
      "url": "https://intranet.cmc.pr.gov.br/bib/",
      "name": "BIB"
    },
    {
      "url": "https://www.curitiba.pr.gov.br/",
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
