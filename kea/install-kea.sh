#! /usr/bin/env bash
# This script installs the Kea DHCP server on a Debian-based system.
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

# Install the Kea DHCP server
echo "Installing Kea DHCP server..."
apt-get install -y kea-dhcp4-server kea-admin


# Install the Kea DHCP config

# Copy the configuration files to the appropriate directory
echo "Installing Kea DHCP config..."
cp -r "$THIS_SCRIPT_DIR/kea/kea-ctrl-agent.conf" /etc/kea/kea-ctrl-agent.conf
cp -r "$THIS_SCRIPT_DIR/kea/kea-dhcp4.conf" /etc/kea/kea-dhcp4.conf



