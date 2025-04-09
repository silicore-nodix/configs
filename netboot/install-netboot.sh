#! /usr/bin/env bash
# This script installs the Netboot server on a Debian-based system.
set -exo pipefail
THIS_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# It is assumed that the script is run with root privileges.
# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Update the package list
echo "Updating package list..."
apt-get update && apt-get upgrade -y

sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo rm /etc/resolv.conf
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Install the Netboot server
echo "Installing Netboot server..."
sudo apt install dnsmasq tftp-hpa -y

sudo mkdir -p /srv/tftp
# Download the Netboot.xyz iPXE bootloader and save it to the TFTP directory
wget -qO- https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe | \
    tee /srv/tftp/netboot.xyz.kpxe /srv/tftp/undionly.kpxe >/dev/null

# Move all the .ipxe files to the TFTP directory
sudo mv "$THIS_SCRIPT_DIR/"*.ipxe /srv/tftp/

# Write the configuration to /etc/dnsmasq.conf using printf
cp "$THIS_SCRIPT_DIR/dnsmasq.conf" /etc/dnsmasq.conf

sudo systemctl restart dnsmasq

