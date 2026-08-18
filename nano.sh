#!/bin/bash

NANORC="/etc/nanorc"

if grep -qxF 'set linenumbers' "$NANORC"; then
    echo "Radnumrering är redan aktiverad."
else
    echo 'set linenumbers' | sudo tee -a "$NANORC" > /dev/null
    echo "Radnumrering har aktiverats i $NANORC."
fi

