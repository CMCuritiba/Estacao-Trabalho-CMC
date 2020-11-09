#!/bin/bash

USUARIO=$(who | head -1 | awk \{'print$1'\})

# Define os atalhos e modelos padrões do Libreoffice e o Deadbeef como aplicativo padrão para reproduzir .ogg para todos os próximos usuários criados:
mkdir -p /etc/skel/.config/libreoffice/4/user/template

sed -i '/^audio\/ogg=deadbeef.desktop$/a\audio\/x-vorbis+ogg=deadbeef.desktop' /etc/skel/.config/mimeapps.list
sed -i '/^audio\/ogg=deadbeef.desktop;$/a\audio\/x-vorbis+ogg=deadbeef.desktop;' /etc/skel/.config/mimeapps.list

cp ./Modelo_taq_etv4.ott /etc/skel/.config/libreoffice/4/user/template/
cp ./registrymodifications.xcu /etc/skel/.config/libreoffice/4/user/

# Define os atalhos e modelos padrões do Libreoffice e o Deadbeef como aplicativo padrão para reproduzir .ogg para o usuário que está logado:
if [ "$USUARIO" != "root" ] && [ "$USUARIO" != "suporte" ]; then
   # Copia o arquivo contendo os atalhos do DeadBeef para o usuário logado:
   mkdir -p "/home/$USUARIO/.config/deadbeef/"
   cp ./taqconfig "/home/$USUARIO/.config/deadbeef/config"

   mkdir -p "/home/$USUARIO/.config/libreoffice/4/user/template"

   sed -i '/^audio\/ogg=deadbeef.desktop$/a\audio\/x-vorbis+ogg=deadbeef.desktop' "/home/$USUARIO/.config/mimeapps.list"
   sed -i '/^audio\/ogg=deadbeef.desktop;$/a\audio\/x-vorbis+ogg=deadbeef.desktop;' "/home/$USUARIO/.config/mimeapps.list"

   cp ./Modelo_taq_etv4.ott "/home/$USUARIO/.config/libreoffice/4/user/template/"
   cp ./registrymodifications.xcu "/home/$USUARIO/.config/libreoffice/4/user/"

   chown -R "$USUARIO:cmc" "/home/$USUARIO/.config/"
fi

# Atualiza atalho do SAT para Firefox e Chrome

if grep -q "\[BookmarksToolbar\]" /usr/lib/firefox-esr/distribution/distribution.ini; then
   echo "item.12.title=SAT Visualizar
	item.12.link=https://intranet.cmc.pr.gov.br/sat/visualizar.xhtml" >>/usr/lib/firefox-esr/distribution/distribution.ini
fi

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
            "url": "http://intranet.cmc.pr.gov.br/"
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
            "name": "SAAP",
            "type": "url",
            "url": "https://saap.cmc.pr.gov.br/"
         }, {
            "date_added": "13155996445000000",
            "id": "12",
            "name": "APL",
            "type": "url",
            "url": "http://intranet.cmc.pr.gov.br/apl/"
         }, {
            "date_added": "13155996445000000",
            "id": "13",
            "name": "Prefeitura de Curitiba",
            "type": "url",
            "url": "http://www.curitiba.pr.gov.br/"
         }, {
            "date_added": "13155996445000000",
            "id": "14",
            "name": "Suporte",
            "type": "url",
            "url": "http://suporte.cmc.pr.gov.br/"
         }, {
            "date_added": "13155996445000000",
            "id": "16",
            "name": "Chamados",
            "type": "url",
            "url": "https://chamados.cmc.pr.gov.br/"
         }, {
			"date_added": "13155996445000000",
            "id": "17",
            "name": "SAT Visualizar",
            "type": "url",
            "url": "https://intranet.cmc.pr.gov.br/sat/visualizar.xhtml"
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
}' >/etc/skel/.config/google-chrome/Default/Bookmarks
