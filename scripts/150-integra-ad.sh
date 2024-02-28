#!/bin/bash

# Instala SSSD, REALM, KERBEROS e ADCLI
DEBIAN_FRONTEND=noninteractive apt-get -qyf install sssd realmd krb5-user adcli

# Configura arquivo do Kerberos com o nome do domínio e corrige problema de DNS reverso
echo "[libdefaults]
default_realm = ${AD_DOMAIN^^}
dns_lookup_realm = false
dns_lookup_kdc = false
rdns=false
kdc_timesync = 1
ccache_type = 4
forwardable = true
proxiable = true
fcc-mit-ticketflags = true
udp_preference_limit = 0

[realms]
    ${AD_DOMAIN^^} = {
    default_domain = ${AD_DOMAIN,,}
    kdc = ${AD_DOMAIN,,}
    admin_server = ${AD_DOMAIN,,}
}

[domain_realm]
    .${AD_DOMAIN,,} = ${AD_DOMAIN^^}
    ${AD_DOMAIN,,} = ${AD_DOMAIN^^}
" >/etc/krb5.conf

if ! realm list | grep -iq "$AD_DOMAIN"; then
    # Cria o ticket do Kerberos para encontrar o domínio
    echo "$AD_JOIN_PASS" | kinit "$AD_JOIN_USER@${AD_DOMAIN^^}"

    # Adiciona o computador ao domínio
    echo "$AD_JOIN_PASS" | realm join -U "$AD_JOIN_USER" "${AD_DOMAIN^^}"
fi

# Configuração do SSSD para apontar para o domínio e manter cache infinito
echo "# SSSD CMC

[sssd]
domains = ${AD_DOMAIN,,}
config_file_version = 2
services = nss,pam

[nss]

[pam]
# Para não expirar o cache de login
offline_credentials_expiration = 0
offline_failed_login_attempts = 0
offline_failed_login_delay = 0

[domain/${AD_DOMAIN,,}]
realmd_tags = manages-system joined-with-adcli
ad_domain = ${AD_DOMAIN,,}
id_provider = ad
auth_provider = ad
chpass_provider = ad
access_provider = ad
ad_access_filter = (&(objectClass=inetOrgPerson)(employeeNumber=*))

# Para descoberta de DNS
krb5_realm = ${AD_DOMAIN^^}

# Para configurar DNS dinâmico
# dyndns_server = ${AD_DOMAIN,,}
# dyndns_update = True
# dyndns_update_ptr = True
#dyndns_refresh_interval = 43200
#dyndns_ttl = 3600

# Para ter logins offline
cache_credentials = True
krb5_store_password_if_offline = True

# uid para login e criacao de pasta home
enumerate = True
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
" >/etc/sssd/conf.d/01-cmc.conf

# Altera permissão do arquivo sssd.conf
chmod 600 /etc/sssd/conf.d/01-cmc.conf

# Restarta serviços REALMD e SSSD
systemctl restart realmd sssd

# Garante que todas as contas de domínio tenham permissão para autenticação no computador
#realm permit --all

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
