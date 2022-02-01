#!/bin/bash

DEBIAN_FRONTEND=nointeractive apt install davfs2  libpam-mount -yq
chmod u+s /sbin/mount.davfs

usermod -aG davfs2 "$USER"
mkdir -p "$HOME/owncloud"
chown "$USER":"$USER" "$HOME/owncloud"

E=$(diff /etc/security/pam_mount.conf.xml ../arquivos/pam_mount.template.conf)
if [ -z "$E" ]; then
	cp ../arquivos/template_pam.conf /etc/security/pam_mount.conf.xml
fi
