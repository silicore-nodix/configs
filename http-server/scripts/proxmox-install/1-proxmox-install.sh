#!/usr/bin/env bash

# Récupérer les informations réseau
DRY_RUN=0
SRV_IP=$(ip route get 1.1.1.1 | awk 'NR==1 {print $7}')
SRV_IFACE=$(ip route | awk '/default/ {print $5}')

# check if we are running in preseed mode (we have a /target directory)
if [ -d /target ]; then
    ROOT_DIR=/target
else
    ROOT_DIR=/
fi
    
export DEBIAN_FRONTEND=noninteractive

# Définir le nom d'hôte
if [ -n "$1" ]; then
    NEW_HOSTNAME=$1
else
    NEW_HOSTNAME="node$(ip link show "$SRV_IFACE" | awk '/ether/ {print $2}' | awk -F: '{printf "%s%s", $5, $6}')"
fi

# Fichiers de configuration
if [ $DRY_RUN -eq 1 ]; then
    NET_FILE="./interfaces"
    HOST_FILE="./hostname"
    HOSTS_FILE="./hosts"
else
    NET_FILE="$ROOT_DIR/etc/network/interfaces"
    HOST_FILE="$ROOT_DIR/etc/hostname"
    HOSTS_FILE="$ROOT_DIR/etc/hosts"
fi

# 1. Configuration de /etc/network/interfaces
echo "Création du fichier $NET_FILE"
tee $NET_FILE <<EOF
auto lo
iface lo inet loopback

auto $SRV_IFACE
iface $SRV_IFACE inet dhcp
    pre-up sed -i '/^send dhcp-client-identifier/d' /etc/dhcp/dhclient.conf || true
    pre-up echo 'send dhcp-client-identifier "";' >> /etc/dhcp/dhclient.conf
EOF

# 2. Changement du nom d'hôte
echo "Création du fichier $HOST_FILE"
echo "$NEW_HOSTNAME" | tee $HOST_FILE
echo "Mise à jour de l'entrée dans $HOSTS_FILE"
sed -i '/127\.0\.1\.1/d' $HOSTS_FILE
echo "$SRV_IP $NEW_HOSTNAME" | tee -a $HOSTS_FILE
echo "127.0.1.1 $NEW_HOSTNAME" | tee -a $HOSTS_FILE

# 3. Ajout des dépôts Proxmox
echo "Ajout des dépôts Proxmox"
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > $ROOT_DIR/etc/apt/sources.list.d/pve-install-repo.list
wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O $ROOT_DIR/etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg 
apt update -y && apt full-upgrade -y
apt install proxmox-default-kernel -y
echo "Installation de Proxmox terminée. Le serveur va redémarrer dans 10 secondes."
