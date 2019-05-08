#!/bin/bash
# Instala LDAP
apt-get -qyf install libnss-ldapd libpam-ldapd nscd nslcd nfs-common


# Para que o diretório home seja criado automaticamente no primeiro login:
if ! grep -q "pam_mkhomedir.so" /etc/pam.d/common-session; then
	echo "session required pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session
fi

sed -i '/^uri/c\uri ldap:\/\/10.0.0.5\/' /etc/nslcd.conf 
sed -i '/^base/c\base ou=Usuarios,dc=pr,dc=gov,dc=br\nbase ou=Grupos,dc=pr,dc=gov,dc=br' /etc/nslcd.conf 

service nslcd restart
