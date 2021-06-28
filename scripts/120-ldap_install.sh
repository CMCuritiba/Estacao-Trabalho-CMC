#!/bin/bash
# Instala LDAP
apt-get -qyf install libnss-ldapd libpam-ldapd nscd nslcd nfs-common


# Para que o diretório home seja criado automaticamente no primeiro login:
if ! grep -q "pam_mkhomedir.so" /etc/pam.d/common-session; then
	echo "session required pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session
fi

NSLCDCONF=/etc/nslcd.conf # type: string path (caminho do nslcd.conf no Mint)
if [ ! -f  "$NSLCDCONF" ]; then
	exit 1;
fi

# Backup da configuração
cp -a "$NSLCDCONF" "$NSLCDCONF-$(date +%F)"

sed -i '/^uri/c\uri ldap:\/\/10.0.0.5\/ ldap:\/\/10.0.0.55\/' "$NSLCDCONF"
sed -i '/^base/c\base ou=Usuarios,dc=pr,dc=gov,dc=br\nbase ou=Grupos,dc=pr,dc=gov,dc=br' "$NSLCDCONF"

# Habilita bind no LDAP
if ! grep -q "^binddn" "$NSLCDCONF"; then
    # Requer input
	echo "Digite o DN completo do usuário de bind:"
    read -r binddn
	echo "Digite a senha do usuário de bind:"
    read -s -r bindpw

    if [ -z "$binddn" ] || [ -z "$bindpw" ]; then
        echo "Erro: DN ou senha inválido."
        exit 2
    fi

    sed -i "/^#binddn/c\binddn $binddn" "$NSLCDCONF"
    sed -i "/^#bindpw/c\bindpw $bindpw" "$NSLCDCONF"
fi

# Otimiza timeout de bind
if ! grep -q "^bind_timelimit" "$NSLCDCONF"; then
    echo -e "\nbind_timelimit 2" >> "$NSLCDCONF"
fi

service nslcd restart
