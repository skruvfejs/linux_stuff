#!/bin/bash

# screwface@linuxmint:~/Projects/linux_stuff$ tree
# .
# ├── file1.examplea
# ├── file2..example
# ├── folder1
# │   ├── file03..example
# │   └── file04.example
# └── file05.example

# validate sudo and get password
sudo -v

# -y = yes on install
sudo apt update
sudo apt install -y tree

# show tree
tree
