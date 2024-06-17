#!/bin/bash

instalador_rede="/mnt/suporte/etv4/scripts/files/zoom_amd64.deb"
instalador_internet="/tmp/zoom_amd64.deb"

if [ -f "$instalador_rede" ]; then
    ZOOM_VERSION_AVAILABLE=$(dpkg-deb -I $instalador_rede | grep Version | awk '{print $2}')
    # echo "ultima versão disponível para download: $ZOOM_VERSION_AVAILABLE"
else
    if ! wget --quiet --continue "https://zoom.us/client/latest/zoom_amd64.deb" --output-document="$instalador_internet"; then
        logger "[$0] ERRO ao baixar instalador zoom da internet."
        exit 1
    fi
    ZOOM_VERSION_AVAILABLE=$(dpkg-deb -I "$instalador_internet" | grep Version | awk '{print $2}')
    # echo "ultima versão disponível para download: $ZOOM_VERSION_AVAILABLE"
fi

ZOOM_VERSION_INSTALLED=$(apt-cache policy zoom | grep -E "Installed|Instalado" | awk '{print $2}')
# echo "versão do zoom instalada: $ZOOM_VERSION_INSTALLED"
if [[ "$ZOOM_VERSION_INSTALLED" != *"$ZOOM_VERSION_AVAILABLE"* ]]; then
    if [ -f "$instalador_rede" ]; then
        # echo "pasta mnt/suporte encontrada"
        export DEBIAN_FRONTEND=noninteractive
        if ! apt-get install -qy "$instalador_rede"; then
            logger "[$0] ERRO ao instalar zoom via rede local."
        fi
    else
        # echo pasta mnt/suporte não encontrada
        export DEBIAN_FRONTEND=noninteractive
        if ! apt-get install -qy "$instalador_internet"; then
            logger "[$0] ERRO ao instalar zoom da internet."
        fi
    fi
    logger "[$0] zoom atualizado para versão $ZOOM_VERSION_AVAILABLE."
fi

# if [ ! -f "/etc/skel/Desktop/Zoom.desktop" ] &&
#     [ -f "/usr/share/applications/Zoom.desktop" ]; then
#     cp /usr/share/applications/Zoom.desktop \
#         /etc/skel/Desktop/Zoom.desktop
# fi
