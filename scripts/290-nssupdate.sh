#!/bin/bash
# ARQUIVOS EM CRON.* NÃO PODEM TER NADA ALÉM DE LETRAS, NÚMERO, HÍFEN E
# UNDERSCORE NO NOME (NÃO PODEM TER PONTO)

echo "#!/bin/bash
nss_updatedb ldap
exit 0" > /etc/cron.hourly/nssupdate

chmod +x /etc/cron.hourly/nssupdate
