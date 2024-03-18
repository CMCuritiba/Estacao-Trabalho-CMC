#!/bin/bash

# LOGR="/etc/logrotate.d/rsyslog"
LOGR="./rsyslog"
if ! grep -q "rotate 27" "$LOGR" ||
    ! grep -q "weekly" "$LOGR"; then
    # Faz um backup (arquivos com a extensao .dpkg-old são ignorados pelo
    # logrotate)

    # Altera tempo de retencao do syslog, auth, messages e outros para 6 meses
    # rotacionados semanalmente
    sed -i"-$(date +%F-%T).dpkg-old" "s/rotate.\+/rotate 27/" "$LOGR"
    sed -i "s/daily/weekly/" "$LOGR"
fi
