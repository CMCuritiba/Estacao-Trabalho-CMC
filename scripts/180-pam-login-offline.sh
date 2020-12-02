#!/bin/bash

######################################################################################################################################################################################################
# Autora: Renata Carvalho
# Data: 08/12/17
# Versão: 1.0
# Descrição: Esse script modifica as configurações do PAM para que este guarde o cache dos users corretamente e permita o login offline, permitindo o uso dos programas locais.
######################################################################################################################################################################################################

if [ ! -f "/etc/pam.d/common-auth" ] && [ ! -f "/etc/pam.d/common-account" ]; then
	exit 1
fi

#if [ ! -f  "/etc/pam.d/common-session" ]; then
#	exit 1;
#fi

#Backup dos antigos
cp -af /etc/pam.d/common-auth /etc/pam.d/common-auth-old
cp -af /etc/pam.d/common-account /etc/pam.d/common-account-old
cp -af /etc/pam.d/common-session /etc/pam.d/common-session-old

#Instalacao dos pacotes necessarios
apt-get install -qyf libnss-ldapd nss-updatedb libnss-db libpam-ccreds

echo "#
# /etc/pam.d/common-auth - authentication settings common to all services
#
# This file is included from other service-specific PAM config files,
# and should contain a list of the authentication modules that define
# the central authentication scheme for use on the system
# (e.g., /etc/shadow, LDAP, Kerberos, etc.).  The default is to use the
# traditional Unix authentication mechanisms.
#
# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.
# To take advantage of this, it is recommended that you configure any
# local modules either before or after the default block, and use
# pam-auth-update to manage selection of other modules.  See
# pam-auth-update(8) for details.

# here are the per-package modules (the \"Primary\" block)
auth    [success=4 default=ignore]      pam_unix.so     nullok_secure
auth    [success=1 authinfo_unavail=ignore default=2]   pam_ldap.so     use_first_pass
auth    [success=2 default=1]   pam_ccreds.so   action=validate use_first_pass
auth    [default=1]     pam_ccreds.so   action=store
# here's the fallback if no module succeeds
auth    requisite       pam_deny.so
# prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success code
# since the modules above will each just jump around
auth	required	pam_permit.so
# and here are more per-package modules (the \"Additional\" block)
# end of pam-auth-update config" >/etc/pam.d/common-auth

echo "#
# /etc/pam.d/common-account - authorization settings common to all services
#
# This file is included from other service-specific PAM config files,
# and should contain a list of the authorization modules that define
# the central access policy for use on the system.  The default is to
# only deny service to users whose accounts are expired in /etc/shadow.
#
# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.
# To take advantage of this, it is recommended that you configure any
# local modules either before or after the default block, and use
# pam-auth-update to manage selection of other modules.  See
# pam-auth-update(8) for details.
#

# here are the per-package modules (the \"Primary\" block)
account	[success=2 new_authtok_reqd=done default=ignore]	pam_unix.so 
account	[success=1 authinfo_unavail=1 default=ignore]	pam_ldap.so
# here's the fallback if no module succeeds
account	requisite	pam_deny.so
# prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success code
# since the modules above will each just jump around
account	required	pam_permit.so
# and here are more per-package modules (the \"Additional\" block)
# end of pam-auth-update config" >/etc/pam.d/common-account

echo "#
# /etc/pam.d/common-session - session-related modules common to all services
#
# This file is included from other service-specific PAM config files,
# and should contain a list of modules that define tasks to be performed
# at the start and end of sessions of *any* kind (both interactive and
# non-interactive).
#
# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.
# To take advantage of this, it is recommended that you configure any
# local modules either before or after the default block, and use
# pam-auth-update to manage selection of other modules.  See
# pam-auth-update(8) for details.

# here are the per-package modules (the \"Primary\" block)
session	[default=1]			pam_permit.so
# here's the fallback if no module succeeds
session	requisite			pam_deny.so
# prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success code
# since the modules above will each just jump around
session	required			pam_permit.so
# The pam_umask module will set the umask according to the system default in
# /etc/login.defs and user settings, solving the problem of different
# umask settings with different shells, display managers, remote sessions etc.
# See \"man pam_umask\".
session	required    pam_mkhomedir.so silent umask=0022 skel=/etc/skel
session	required	pam_unix.so 
session	optional	pam_mount.so 
session	optional	pam_ldap.so 
session	optional	pam_systemd.so 
# and here are more per-package modules (the \"Additional\" block)
# end of pam-auth-update config" >/etc/pam.d/common-session

#Config final do arquivo nsswitch.
sed -i '/^passwd:/c\passwd: compat files ldap \[NOTFOUND=return\] db' /etc/nsswitch.conf
sed -i '/^group:/c\group: compat files ldap \[NOTFOUND=return\] db' /etc/nsswitch.conf
