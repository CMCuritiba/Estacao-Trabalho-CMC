#!/bin/bash

if ! grep "rotate 27" "/etc/logrotate.d/rsyslog"; then
    # Faz um backup (arquivos com a extensao dpkg-old são ignorados pelo
    # logrotate)
    cp -au "/etc/logrotate.d/rsyslog" "/etc/logrotate.d/rsyslog.dpkg-old"

    # Altera tempo de retencao do syslog, auth, messages e outros para 6 meses
    # rotacionados semanalmente (utilizando perl para lidar com as quebras de
    # linha mais facilmente)
    perl -i -p0e 's/syslog[\n\s]*{[\n\s]*rotate\s+7[\n\s]*daily/syslog\n{\n\trotate 27\n\tweekly/g' "/etc/logrotate.d/rsyslog"
    perl -i -p0e 's/messages[\n\s]*{[\n\s]*rotate\s+4/messages\n{\n\trotate 27/g' "/etc/logrotate.d/rsyslog"
fi

