#!/bin/bash

# Script deve ser rodado como root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    logger "Este script deve ser executado como root"
    exit 1
fi

# Instala favoritos gerenciados no Firefox
# Referencia para policies:
# https://github.com/mozilla/policy-templates/blob/v1.17/README.md
favsFirefox="/usr/lib/firefox-esr/distribution/policies.json"  # type: json file
if [[ ! -f "$favsFirefox" ]] || ! grep -iq "eloweb" "$favsFirefox"; then
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
        "url": "https://mail.cmc.pr.gov.br",
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
        "url": "https://acesso.cmcuritiba.eloweb.net/",
        "name": "Eloweb Gestão Pública"
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
}' > "$favsFirefox"
fi

# Instala atalho gerenciado no Google Chrome
# Referencia para policies:
# https://cloud.google.com/docs/chrome-enterprise/policies/
favsChrome="/etc/opt/chrome/policies/managed/cmc.json" # type: json file
if [[ ! -f "$favsChrome" ]] || ! grep -iq "eloweb" "$favsChrome"; then
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
      "url": "https://mail.cmc.pr.gov.br",
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
      "url": "https://acesso.cmcuritiba.eloweb.net/",
      "name": "Eloweb Gestão Pública"
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
}' > "$favsChrome"
fi
