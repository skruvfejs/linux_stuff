#!/bin/bash
#
# Adds ll for all users (globally in /etc/bash.bashrc")

#!/bin/bash

FILE="/etc/profile.d/custom-aliases.sh"

sudo tee "$FILE" > /dev/null <<'EOF'
# Custom aliases
alias ll='ls -lah --color=auto'
EOF

sudo chmod 644 "$FILE"

echo "Alias ll har lagts till för alla användare."
