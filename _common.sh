#!/bin/bash
USER="screwface"

# Fixing sudo
su
/usr/sbin/usermod -aG sudo $USER

id screwface
# Returning groups
# uid=1000(screwface) gid=1000(screwface) grupper=1000(screwface),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),100(users),101(netdev)
#                                                                                      ^^^^^^^^ 

# Fixing ll command
# Usage: ll
echo "alias ll='ls -lah --color=auto'" >> ~/.bashrc
source ~/.bashrc

# Updating repository
sudo apt update

# Installing most common
sudo apt install mc

