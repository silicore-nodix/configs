#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive


# 4. Install les paquets restant
apt update && apt install proxmox-ve postfix open-iscsi chrony -y


# 5. Suppression du kernel de Debian
apt remove linux-image-amd64 'linux-image-6.1*' -y

# 6. Configuration de GRUB_CMDLINE_LINUX_DEFAULT
echo "Mise à jour de GRUB_CMDLINE_LINUX_DEFAULT"
sed -i  's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="netcfg\/disable_autoconfig=true apparmor=0"/' /etc/default/grub
update-grub

# 7. Remover le paquet "os-prober"
apt remove os-prober -y
