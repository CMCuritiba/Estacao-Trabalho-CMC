#!/bin/bash
# Configura servidor NTP para ser o da Câmara

echo '# Servidor da camara
server  ntp1.cmc.pr.gov.br
server  ntp2.cmc.pr.gov.br

# Loops locais
server  127.127.1.0
fudge   127.127.1.0 stratum 10

# Tokyo Drift
driftfile /var/lib/ntp/ntp.drift' > /etc/ntp.conf

