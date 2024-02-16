#!/bin/bash

instalador_remoto="/mnt/suporte/etv4/scripts/files/zoom_amd64.deb"
instalador_local="/tmp/zoom_amd64.deb"

if [ -f "$instalador_remoto" ]; then
    ZOOM_VERSION_AVAILABLE=$(dpkg-deb -I $instalador_remoto | grep Version)
    # echo "ultima versão disponível para download: $ZOOM_VERSION_AVAILABLE"
else
    if ! wget --quiet --continue "https://zoom.us/client/latest/zoom_amd64.deb" --output-document="$instalador_local"; then
        logger "[$0] ERRO ao baixar instalador zoom da internet."
        exit 1
    fi
    ZOOM_VERSION_AVAILABLE=$(dpkg-deb -I "$instalador_local" | grep Version)
    # echo "ultima versão disponível para download: $ZOOM_VERSION_AVAILABLE"
fi

ZOOM_VERSION_INSTALLED=$(apt-cache policy zoom | grep "Installed:" | sed -e 's/.*Installed: \(.*\)/\1/')
# echo "versão do zoom instalada: $ZOOM_VERSION_INSTALLED"
if [ -f "$instalador_remoto" ] && [[ "$ZOOM_VERSION_INSTALLED" != *"$ZOOM_VERSION_AVAILABLE"* ]]; then
    # echo "pasta mnt/suporte encontrada"
    export DEBIAN_FRONTEND=noninteractive
    if ! apt-get install -qy "$instalador_remoto"; then
        logger "[$0] ERRO ao instalar zoom via rede local."
    fi
else
    # echo pasta mnt/suporte não encontrada
    export DEBIAN_FRONTEND=noninteractive
    if ! apt-get install -qy "$instalador_local"; then
        logger "[$0] ERRO ao instalar zoom da internet."
    fi
fi
