#!/bin/bash
# Instala o unattended-upgrades
apt-get -qyf install unattended-upgrades

# Adiciona os repositório relevantes ao arquivo de configuração
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"${distro_id}:${distro_codename}-updates\";' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"LP-PPA-mozillateam:xenial\";' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"LP-PPA-webupd8team-java:trusty\";' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"Google\\, Inc.:stable\";' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"Ubuntu:xenial-security";' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"Ubuntu:xenial";' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"Ubuntu:xenial-updates";' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i '/Unattended-Upgrade::Allowed-Origins {/a\\t\"obs:\/\/build.opensuse.org\/isv:ownCloud:desktop\/Ubuntu_16.04:Ubuntu_16.04";' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's|//Unattended-Upgrade::MinimalSteps "true";|Unattended-Upgrade::MinimalSteps "true";|' /etc/apt/apt.conf.d/50unattended-upgrades

