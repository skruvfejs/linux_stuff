#!/bin/bash

USER="screwface"


# ================================================================================================
# SUDO
# ================================================================================================
# Starta om scriptet med sudo om det inte redan körs som root
if [[ $EUID -ne 0 ]]; then
    exec sudo "$0" "$@"
fi

# Lägg till användaren i sudo-gruppen
usermod -aG sudo "$USER"
echo "Grupper för $USER:"
id "$USER"




# ===============================================================================================
# Fixing ll command
# ===============================================================================================
# Usage: ll
echo "alias ll='ls -lah --color=auto'" >> ~/.bashrc
source ~/.bashrc

# Updating repository
sudo apt update

# Installing most common
sudo apt install mc

