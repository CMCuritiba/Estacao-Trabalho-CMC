#!/bin/bash
# Seta confs de instalação do LDAP
echo '
Name: nslcd/ldap-uris
Template: nslcd/ldap-uris
Value: '"$SERV_LDAP"'
Owners: nslcd
Flags: seen

Name: nslcd/ldap-base
Template: nslcd/ldap-base
Value: '"$LDAP_USERS_DN"' '"$LDAP_GROUPS_DN"'
Owners: nslcd
Flags: seen

Name: libnss-ldapd/nsswitch
Template: libnss-ldapd/nsswitch
Value: passwd, group, shadow
Owners: libnss-ldapd, libnss-ldapd:amd64
Flags: seen
' >> /var/cache/debconf/config.dat

# Instala LDAP
DEBIAN_FRONTEND=noninteractive apt-get -qyf install libnss-ldapd libpam-ldapd nscd nslcd nfs-common

# Para que o diretório home seja criado automaticamente no primeiro login:
if ! grep -q "pam_mkhomedir.so" /etc/pam.d/common-session; then
	echo "session required pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session
fi

sed -i '/^uri/c\uri '"$SERV_LDAP" /etc/nslcd.conf
sed -i '/^base/c\base '"$LDAP_USERS_DN"'\nbase '"$LDAP_GROUPS_DN" /etc/nslcd.conf

# faz bind no LDAP
if ! grep -q "^binddn" /etc/nslcd.conf; then
	sed -i '/^#binddn/c\binddn '"$BIND_DN" /etc/nslcd.conf
	sed -i '/^#bindpw/c\bindpw '"$BIND_PW" /etc/nslcd.conf
fi
systemctl restart nslcd.service