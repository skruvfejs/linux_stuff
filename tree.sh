#!/bin/bash

sudo apt update
sudo apt tree

tree

# screwface@mail:~/Projects/screwface-firewall$ tree
# .
# ├── allowlist.conf.example
# ├── denylist.conf.example
# ├── firewall.conf.example
# ├── install.sh
# ├── LICENSE
# ├── lists
# │   ├── mailclients.allow.example
# │   ├── smtp.deny.example
# │   ├── ssh.allow.example
# │   ├── vpn.allow.example
# │   └── web.allow.example
# ├── logs
# │   └── screwface-firewall.log -> /var/log/screwface-firewall.log
# ├── patch_mailclients_allow.py
# ├── ports.conf.example
# ├── README.md
# ├── scripts
# │   └── screwface-firewall.sh
# ├── special.conf.example
# └── uninstall.sh

