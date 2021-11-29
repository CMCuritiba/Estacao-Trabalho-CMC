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

NSLCDCONF=/etc/nslcd.conf # type: string path (caminho do nslcd.conf no Mint)
if [ ! -f  "$NSLCDCONF" ]; then
	exit 1;
fi

# Backup da configuração
cp -af --backup=t "$NSLCDCONF" "$NSLCDCONF-old"

# Habilita bind no LDAP
if ! grep -q "^binddn" "$NSLCDCONF"; then
    echo "binddn $BIND_DN" "$NSLCDCONF"
fi
if ! grep -q "^bindpw" "$NSLCDCONF"; then
    echo "bindpw $BIND_PW" "$NSLCDCONF"
fi

# Otimiza timeout de bind
if ! grep -q "^bind_timelimit" "$NSLCDCONF"; then
    echo -e "\nbind_timelimit 2" >> "$NSLCDCONF"
fi

systemctl restart nslcd.service
