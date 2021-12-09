#!/bin/bash

USUARIO=$(who | head -1 | awk \{'print$1'\})

# Define os atalhos e modelos padrões do Libreoffice para todos os próximos
# usuários criados:
mkdir -p /etc/skel/.config/libreoffice/4/user/template

cp ./Modelo_taq_etv4.ott /etc/skel/.config/libreoffice/4/user/template/
cp ./registrymodifications.xcu /etc/skel/.config/libreoffice/4/user/

# Define os atalhos e modelos padrões do Libreoffice para todos os próximos
# usuários criados:
if [ "$USUARIO" != "root" ] && [ "$USUARIO" != "suporte" ]; then
    # Copia o template do LibreOffice para o usuário logado:
    mkdir -p "/home/$USUARIO/.config/libreoffice/4/user/template"
    cp ./Modelo_taq_etv4.ott "/home/$USUARIO/.config/libreoffice/4/user/template/"
    cp ./registrymodifications.xcu "/home/$USUARIO/.config/libreoffice/4/user/"

    chown -R "$USUARIO:cmc" "/home/$USUARIO/.config/"
fi
