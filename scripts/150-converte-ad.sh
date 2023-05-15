#!/bin/bash

# Instala SSSD, REALM, KERBEROS e ADCLI
DEBIAN_FRONTEND=noninteractive apt-get -qyf install sssd realmd krb5-user adcli

# Configura arquivo do Kerberos com o nome do domínio e corrige problema de DNS reverso
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

# Cria o ticket do Kerberos para encontrar o domínio
echo $AD_JOIN_PWD | kinit $AD_JOIN@$AD_DOMAIN

# Adiciona o computador ao domínio
echo $AD_JOIN_PWD | realm join -U $AD_JOIN $AD_DOMAIN

# Configuração do SSSD para apontar para o domínio e manter cache infinito
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

# Altera permissão do arquivo sssd.conf
chmod 600 /etc/sssd/sssd.conf

# Restarta o serviço SSSD
systemctl restart sssd
