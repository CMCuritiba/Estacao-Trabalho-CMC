#!/bin/bash
# Instala LDAP
apt-get -qyf install libnss-ldapd libpam-ldapd nscd nslcd nfs-common

# Para que o diretório home seja criado automaticamente no primeiro login:
if ! grep -q "pam_mkhomedir.so" /etc/pam.d/common-session; then
	echo "session required pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session
fi

sed -i '/^uri/c\uri ldap://'"$SERV_LDAP"'/' /etc/nslcd.conf
sed -i '/^base/c\base '"$DN_BASE1_LDAP"'\nbase '"$DN_BASE2_LDAP" /etc/nslcd.conf

# faz bind no LDAP
if ! grep -q "^binddn" /etc/nslcd.conf; then
	sed -i '/^#binddn/c\binddn '"$BIND_DN" /etc/nslcd.conf
	sed -i '/^#bindpw/c\bindpw '"$BIND_PW" /etc/nslcd.conf
fi
systemctl restart nslcd.service