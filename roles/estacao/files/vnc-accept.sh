#!/bin/bash
# Exibe diálogo de confirmação ao receber conexão VNC
XAUTH=$(ls /home/*/.Xauthority 2>/dev/null | head -1)
export DISPLAY=:0
export XAUTHORITY="$XAUTH"

zenity --question \
    --title="Suporte Técnico - Acesso Remoto" \
    --text="A DTIC está solicitando acesso à sua tela para acesso remoto.\n\nVocê autoriza?" \
    --ok-label="Sim, autorizo" \
    --cancel-label="Não, recusar" \
    --timeout=30
