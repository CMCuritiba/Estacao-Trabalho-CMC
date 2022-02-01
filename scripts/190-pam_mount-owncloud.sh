#!/bin/bash

DEBIAN_FRONTEND=nointeractive apt install davfs2  libpam-mount -yq
chmod u+s /sbin/mount.davfs

mkdir -p "$HOME/owncloud"
chown "$USER":"$USER" "$HOME/owncloud"

if ! cmp -s /etc/security/pam_mount.conf.xml ../arquivos/pam_mount.template.conf; then
    cp -f ../arquivos/pam_mount.template.conf /etc/security/pam_mount.conf.xml
fi
