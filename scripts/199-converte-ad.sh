#!/bin/bash

# Update e Upgrade inicial
apt-get update
apt-get -y upgrade

# Remove configuracao do LDAP
DEBIAN_FRONTEND=noninteractive apt-get -qyf purge libnss-ldap libpam-ldap nscd nslcd

# Instala SSSD, REALM, KERBEROS e ADCLI
DEBIAN_FRONTEND=noninteractive apt-get -qyf install sssd realmd krb5-user adcli

# Remove resolv.conf para usar configuracao local e apontar para o IP do DNS do AD
rm -rf /etc/resolv.conf
echo "nameserver $AD_ADDRESS" > /etc/resolv.conf

if ! grep -w "${AD_DOMAIN,,}" "/etc/systemd/resolved.conf"; then
    sed -i "/Domains=cmc.pr.gov.br/c\Domains=${AD_DOMAIN,,}" "/etc/systemd/resolved.conf"
fi

# Informa o nome do computador
echo "Informe o novo nome do computador (ENTER para manter o nome atual '$('hostname')'): "
read HOST

# Verifica se variavel HOST está vazia ou com valor indefinidos
if [ -z $HOST ] || [ $HOST == "3NXDOMAIN" ]; then
    HOST=$HOSTNAME
fi

# Altera o hostname do computador
hostnamectl set-hostname $HOST

# Altera arquivo 'hostname' para o novo nome com o dominio (minusculo)
echo $HOST > /etc/hostname

# Altera arquivo 'hosts' para o novo nome com o dominio (minusculo)
sed -i "/^127.0.1.1/c\127.0.1.1\t"$HOST.${AD_DOMAIN,,} "/etc/hosts"

# Ajuste o servico SSH para permitir autenticacao de senha
sed -i "/#PasswordAuthentication yes/c\PasswordAuthentication yes" "/etc/ssh/sshd_config"

# Restarta o servico SSH
systemctl restart sshd

# Configura arquivo do Kerberos com o nome do dominio e corrige problema de DNS reverso
echo "[libdefaults]
default_realm = $AD_DOMAIN
rdns=false
kdc_timesync = 1
ccache_type = 4
forwardable = true
proxiable = true
fcc-mit-ticketflags = true
udp_preference_limit = 0
" > /etc/krb5.conf

# Cria o ticket do Kerberos para encontrar o dominio
echo $AD_ADMIN_PWD | kinit $AD_ADMIN@$AD_DOMAIN

# Adiciona o computador ao dominio
echo $AD_ADMIN_PWD | realm join -U $AD_ADMIN $AD_DOMAIN

# Configuracao do SSSD para apontar para o dominio e manter cache infinito
echo "[sssd]
domains = ${AD_DOMAIN,,}
config_file_version = 2
services = nss,pam

[nss]

[pam]
offline_credentials_expiration = 0
offline_failed_login_attempts = 0
offline_failed_login_delay = 0

[domain/${AD_DOMAIN,,}]
realmd_tags = manages-system joined-with-adcli
ad_domain = ${AD_DOMAIN,,}
krb5_realm = $AD_DOMAIN

id_provider = ad
cache_credentials = True
krb5_store_password_if_offline = True
enumerate = true
use_fully_qualified_names = False

fallback_homedir = /home/%u
default_shell = /bin/bash

# para usar uid and gid do active directory
ldap_id_mapping = False

# necessario para uso correto das propriedades do active directory
ldap_schema = ad
ldap_user_object_class = InetOrgPerson
ldap_user_name = uid
ldap_user_gid_number = gidNumber
ldap_user_uid_number = uidNumber
ldap_user_gecos = displayName
" > /etc/sssd/sssd.conf

# Altera permissao do arquivo sssd.conf
chmod 600 /etc/sssd/sssd.conf

# Restarta o servico SSSD
systemctl restart sssd

# Adiciona grupo com perfil de administrador no arquivo 'sudoers'
if grep -w "dtic" "/etc/sudoers"; then
    sed -i "/%dtic/c\%$AD_GROUP_SUDOERS\tALL=(ALL:ALL) ALL" "/etc/sudoers"
else
    echo -e "\n$AD_GROUP_SUDOERS\tALL=(ALL:ALL) ALL" >> /etc/sudoers
fi

# Configuracao do nsswitch
if ! cmp -s /etc/nsswitch.conf ../arquivos/nsswitch.conf.template; then
    cp -f --backup=t ../arquivos/nsswitch.conf.template /etc/nsswitch.conf
fi

# Automatiza a criacao do diretorio HOME apos o login
pam-auth-update --force --enable mkhomedir

# Configuracao do PAM para trabalhar com SSSD
if ! cmp -s /etc/pam.d/common-auth ../arquivos/common-auth.template; then
    cp -f --backup=t ../arquivos/common-auth.template /etc/pam.d/common-auth
fi
if ! cmp -s /etc/pam.d/common-account ../arquivos/common-account.template; then
    cp -f --backup=t ../arquivos/common-account.template /etc/pam.d/common-account
fi
if ! cmp -s /etc/pam.d/common-session ../arquivos/common-session.template; then
    cp -f --backup=t ../arquivos/common-session.template /etc/pam.d/common-session
fi

echo "SCRIPT ENCERRADO"
