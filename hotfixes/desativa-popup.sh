#!/bin/bash

# Script deve ser rodado como root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    logger "Este script deve ser executado como root"
    exit 1
fi

# Desativa pop-up no boot
rm -f /etc/xdg/autostart/instant.msg.desktop

# Desativa pop-ups
if grep -q "MostraMsg" /usr/local/cmc/scripts/instant.msg.sh; then
    echo "#!/bin/bash
exit 0" > /usr/local/cmc/scripts/instant.msg.sh
fi
