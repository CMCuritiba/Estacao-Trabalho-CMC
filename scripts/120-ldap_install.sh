#!/bin/bash
# Instala LDAP
apt-get -qyf install libnss-ldapd libpam-ldapd nscd nslcd nfs-common

# Para que o diretório home seja criado automaticamente no primeiro login:
if ! grep -q "pam_mkhomedir.so" /etc/pam.d/common-session; then
	echo "session required pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session
fi

sed -i '/^uri/c\'"$URI_LDAP"'' /etc/nslcd.conf
sed -i '/^base/c\'"$BASE_LDAP"'\n'"$BASE1_LDAP"'' /etc/nslcd.conf 

# faz bind no LDAP
if ! grep -q "^binddn" /etc/nslcd.conf; then
	sed -i '/^#binddn/c\'"$BINDDN"'' /etc/nslcd.conf
	sed -i '/^#bindpw/c\'"$BINDPW"'' /etc/nslcd.conf
fi
systemctl restart nslcd.service
