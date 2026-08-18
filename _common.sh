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



# ===============================================================================================
# Installing most useful stuff
# ===============================================================================================

# Updating repository
sudo apt update

# Installing midnight commander
sudo apt install mc

# Installing locate
sudo apt install locate
sudo updatedb

