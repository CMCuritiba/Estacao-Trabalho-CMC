#!/bin/bash

# Instala favoritos gerenciados no Firefox
# Referencia para policies:
# https://github.com/mozilla/policy-templates/blob/v1.17/README.md
favsFirefox="/usr/lib/firefox-esr/distribution/policies.json"
if [[ ! -f "$favsFirefox" ]] || ! grep -q "Elotech" "$favsFirefox"; then
    echo '{
  "policies": {
    "DisplayBookmarksToolbar": true,
    "Bookmarks": [
      {
        "URL": "https://www.cmc.pr.gov.br/",
        "Title": "Câmara Municipal de Curitiba"
      },
      {
        "URL": "https://intranet.cmc.pr.gov.br/",
        "Title": "Intranet"
      },
      {
        "URL": "https://correio.cmc.pr.gov.br/",
        "Title": "Correio"
      },
      {
        "URL": "https://www.cmc.pr.gov.br/spl/",
        "Title": "SPL II"
      },
      {
        "URL": "https://intranet.cmc.pr.gov.br/spa/",
        "Title": "SPA"
      },
      {
        "URL": "https://nuvem.cmc.pr.gov.br/",
        "Title": "Nuvem"
      },
      {
        "URL": "https://intranet.cmc.pr.gov.br/apl/",
        "Title": "APL"
      },
      {
        "URL": "https://servicos.cmc.pr.gov.br/",
        "Title": "Elotech - Sistema de Gestão"
      },
      {
        "URL": "https://chamados.cmc.pr.gov.br/",
        "Title": "Chamados"
      },
      {
        "URL": "https://suporte.cmc.pr.gov.br/",
        "Title": "Suporte"
      },
      {
        "URL": "https://www.curitiba.pr.gov.br/",
        "Title": "Prefeitura Municipal de Curitiba"
      },
      {
        "URL": "https://web.openrainbow.com/",
        "Title": "Rainbow"
      }
    ]
  }
}' > "$favsFirefox"
fi

# Instala atalho gerenciado no Google Chrome
# TODO: Aparentemente não é possível a edição/inserção programática de atalhos
# nos perfis do Firefox.
# Referencia para policies do Chrome:
# https://cloud.google.com/docs/chrome-enterprise/policies/
favsChrome="/etc/opt/chrome/policies/managed/cmc.json"
if ! grep -q "Elotech" "$favsChrome"; then
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
    "url": "https://servicos.cmc.pr.gov.br/",
    "name": "Elotech - Sistema de Gestão"
  },
  {
    "url": "https://chamados.cmc.pr.gov.br/",
    "name": "Chamados"
  },
  {
    "url": "https://suporte.cmc.pr.gov.br/",
    "name": "Suporte"
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
}' > "$favsChrome"
fi
