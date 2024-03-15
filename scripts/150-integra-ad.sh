#!/bin/bash

# Instala SSSD, REALM, KERBEROS e ADCLI
apt-get -qyf install sssd sssd-tools realmd krb5-user samba-common packagekit adcli

if ! grep -iq "$AD_DOMAIN" <<<"$(hostname -f)"; then
    echo "Hostname não configurado, abortando."
    exit 1
fi

KRBCONF="/etc/krb5.conf"
# Configura arquivo do Kerberos com o domínio e evita problema de DNS reverso
sed -i "s/default_realm.*/default_realm = $AD_DOMAIN/" "$KRBCONF"
if ! grep -Eiq "\s*rdns.+false$" "$KRBCONF"; then
    sed -i "/default_realm/a \\\\trdns = false" "$KRBCONF"
fi

if ! realm list | grep -iq "$AD_DOMAIN"; then
    # Adiciona o computador ao domínio
    echo "$AD_JOIN_PASS" | realm join -U "$AD_JOIN_USER" "${AD_DOMAIN^^}"
fi

# Configuração do SSSD:
# - mapear IDs linux
# - configura diretório home
# - permite login apenas com uid
# - faz cache de senha (permite login offline) TODO: verificar duração
# - desativa atualização dinâmica de DNS
# - TODO: filtra usuários
#
# Ref: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/join_linux_instance.html
echo "# SSSD CMC

[sssd]
domains = ${AD_DOMAIN,,}
config_file_version = 2
services = nss, pam

[domain/${AD_DOMAIN,,}]
ad_domain = ${AD_DOMAIN,,}
krb5_realm = ${AD_DOMAIN^^}
realmd_tags = manages-system joined-with-samba
dyndns_update = False
cache_credentials = True
id_provider = ad
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_id_mapping = False
use_fully_qualified_names = False
fallback_homedir = /home/%u
access_provider = ad
#ad_access_filter = (memberOf=cn=admins,ou=Testou,dc=example,dc=com)
# ad_access_filter = (embployeeNumber=*)
# " >/etc/sssd/conf.d/01-cmc.conf

# Altera permissão do arquivo sssd.conf
chmod 600 /etc/sssd/conf.d/01-cmc.conf

# Restarta serviços REALMD e SSSD
systemctl restart sssd

# Testes com o AD
#
# Verificar o domínio:
#   realm list
#
# Status do domínio:
#   sudo sssctl domain-status example.com
#
# Validar a configuração do SSSD:
#   sudo sssctl config-check
