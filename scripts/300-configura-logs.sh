#!/bin/bash

# No backup, os arquivos com a extensao .dpkg-old são ignorados pelo
# logrotate

LOGR="/etc/logrotate.d/rsyslog"
if ! grep -q "rotate 27" "$LOGR" ||
    ! grep -q "weekly" "$LOGR"; then

    # Altera tempo de retencao do syslog, auth, messages e outros para 6 meses
    # rotacionados semanalmente
    sed -i"-$(date +%F-%T).dpkg-old" "s/rotate.\+/rotate 27/" "$LOGR"
    sed -i "s/daily/weekly/" "$LOGR"
fi

LOGSSSD="/etc/logrotate.d/sssd-common"
if ! grep -q "rotate 27" "$LOGSSSD" ||
    ! grep -q "weekly" "$LOGSSSD"; then

    # Altera tempo de retencao do syslog, auth, messages e outros para 6 meses
    # rotacionados semanalmente
    sed -i"-$(date +%F-%T).dpkg-old" "s/rotate.\+/rotate 27/" "$LOGSSSD"
    sed -i "s/daily/weekly/" "$LOGSSSD"
fi
