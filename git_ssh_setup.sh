#!/bin/bash

set -e

# ============================================================
# GitHub SSH Setup
#
# Kontrollerar SSH-nyckel och konfigurerar aktuellt Git-projekt
# att använda GitHub via SSH istället för HTTPS.
#
# Privat SSH-nyckel lämnar ALDRIG datorn.
# ============================================================

echo "=========================================="
echo " GitHub SSH Setup"
echo "=========================================="
echo

# ------------------------------------------------------------
# Kontrollera Git
# ------------------------------------------------------------

if ! command -v git >/dev/null 2>&1; then
    echo "FEL: Git är inte installerat."
    exit 1
fi

echo "Git: $(git --version)"

# ------------------------------------------------------------
# Kontrollera att vi står i ett Git-projekt
# ------------------------------------------------------------

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo
    echo "FEL: Den aktuella katalogen är inte ett Git-projekt."
    echo
    echo "Gå till projektets katalog och kör scriptet igen."
    exit 1
fi

PROJECT_ROOT="$(git rev-parse --show-toplevel)"

echo "Git-projekt:"
echo "  $PROJECT_ROOT"
echo

# ------------------------------------------------------------
# SSH-katalog
# ------------------------------------------------------------

SSH_DIR="$HOME/.ssh"
PRIVATE_KEY="$SSH_DIR/id_ed25519"
PUBLIC_KEY="$SSH_DIR/id_ed25519.pub"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# ------------------------------------------------------------
# Kontrollera SSH-nyckel
# ------------------------------------------------------------

if [ -f "$PRIVATE_KEY" ] && [ -f "$PUBLIC_KEY" ]; then

    echo "SSH-nyckel hittad:"
    echo "  $PRIVATE_KEY"
    echo "  $PUBLIC_KEY"
    echo

else

    echo "Ingen Ed25519 SSH-nyckel hittades."
    echo
    read -rp "Vill du skapa en ny SSH-nyckel? [J/n]: " CREATE_KEY

    CREATE_KEY="${CREATE_KEY:-J}"

    if [[ "$CREATE_KEY" =~ ^[JjYy]$ ]]; then

        echo
        echo "Skapar ny Ed25519 SSH-nyckel..."
        echo

        ssh-keygen -t ed25519 -C "$(git config user.email 2>/dev/null || echo github)" \
            -f "$PRIVATE_KEY"

        chmod 600 "$PRIVATE_KEY"
        chmod 644 "$PUBLIC_KEY"

        echo
        echo "SSH-nyckel skapad."
        echo

    else
        echo
        echo "Ingen SSH-nyckel skapades."
        echo "Avbryter."
        exit 0
    fi

fi

# ------------------------------------------------------------
# Kontrollera GitHub SSH
# ------------------------------------------------------------

echo "=========================================="
echo " Testar GitHub SSH"
echo "=========================================="
echo

SSH_TEST_OUTPUT="$(ssh -T git@github.com 2>&1 || true)"

echo "$SSH_TEST_OUTPUT"
echo

if echo "$SSH_TEST_OUTPUT" | grep -q "successfully authenticated"; then

    echo "GitHub SSH fungerar."
    echo

else

    echo "GitHub SSH-autentisering fungerar inte ännu."
    echo
    echo "Om detta är en ny SSH-nyckel måste den publika"
    echo "nyckeln först läggas till på GitHub."
    echo
    echo "Din publika nyckel finns här:"
    echo
    echo "  $PUBLIC_KEY"
    echo
    echo "Visa den med:"
    echo
    echo "  cat $PUBLIC_KEY"
    echo
    echo "Lägg sedan till den på GitHub enligt instruktionerna"
    echo "längst ner i detta script."
    echo
fi

# ------------------------------------------------------------
# Kontrollera origin
# ------------------------------------------------------------

if ! git remote get-url origin >/dev/null 2>&1; then
    echo "FEL: Projektet saknar en 'origin'-remote."
    exit 1
fi

ORIGIN="$(git remote get-url origin)"

echo "=========================================="
echo " GitHub Remote"
echo "=========================================="
echo
echo "Nuvarande origin:"
echo "  $ORIGIN"
echo

# ------------------------------------------------------------
# Kontrollera om origin är GitHub
# ------------------------------------------------------------

if [[ "$ORIGIN" != *"github.com"* ]]; then
    echo "Origin verkar inte vara ett GitHub-repository."
    echo "Ingen ändring görs."
    exit 0
fi

# ------------------------------------------------------------
# Konvertera GitHub HTTPS → SSH
# ------------------------------------------------------------

if [[ "$ORIGIN" =~ ^https://github\.com/([^/]+)/([^/]+)(\.git)?$ ]]; then

    GITHUB_USER="${BASH_REMATCH[1]}"
    REPOSITORY="${BASH_REMATCH[2]}"

    SSH_REMOTE="git@github.com:${GITHUB_USER}/${REPOSITORY}.git"

    echo "GitHub HTTPS-remote upptäckt."
    echo
    echo "Ny SSH-remote:"
    echo "  $SSH_REMOTE"
    echo

    read -rp "Ändra origin till SSH? [J/n]: " CHANGE_REMOTE

    CHANGE_REMOTE="${CHANGE_REMOTE:-J}"

    if [[ "$CHANGE_REMOTE" =~ ^[JjYy]$ ]]; then

        git remote set-url origin "$SSH_REMOTE"

        echo
        echo "Origin ändrad."
        echo
        git remote -v

    else

        echo
        echo "Ingen ändring gjordes."
        exit 0
    fi

elif [[ "$ORIGIN" =~ ^git@github\.com: ]]; then

    echo "Origin använder redan GitHub SSH."
    echo "Ingen ändring behövs."

else

    echo "GitHub-remote kunde inte identifieras."
    echo "Ingen ändring gjordes."
fi

# ------------------------------------------------------------
# Testa GitHub-anslutningen
# ------------------------------------------------------------

echo
echo "=========================================="
echo " Testar GitHub-anslutningen"
echo "=========================================="
echo

if git ls-remote origin HEAD >/dev/null 2>&1; then

    echo "GitHub-anslutningen fungerar."
    echo
    echo "KLART!"

else

    echo "GitHub-anslutningen misslyckades."
    echo
    echo "Kontrollera att den publika SSH-nyckeln är"
    echo "registrerad på rätt GitHub-konto."
    exit 1
fi

echo
echo "=========================================="
echo " GitHub SSH Setup"
echo " klart"
echo "=========================================="
echo

# ============================================================
# GitHub Webbsida
# ============================================================
#
# Om en ny SSH-nyckel skapades:
#
# 1. Visa den publika nyckeln:
#
#      cat ~/.ssh/id_ed25519.pub
#
# 2. Logga in på:
#
#      https://github.com
#
# 3. Klicka på profilbilden uppe till höger.
#
# 4. Välj:
#
#      Settings
#
# 5. Välj:
#
#      SSH and GPG keys
#
# 6. Klicka:
#
#      New SSH key
#
# 7. Skriv exempelvis:
#
#      Linux Mailserver
#
# 8. Klistra in HELA innehållet från:
#
#      ~/.ssh/id_ed25519.pub
#
# 9. Klicka:
#
#      Add SSH key
#
# 10. Testa sedan:
#
#      ssh -T git@github.com
#
# Ett lyckat resultat är ungefär:
#
#      Hi USERNAME! You've successfully authenticated,
#      but GitHub does not provide shell access.
#
# VIKTIGT:
#
# Lägg ALDRIG upp:
#
#      ~/.ssh/id_ed25519
#
# på GitHub.
#
# Det är den PRIVATA nyckeln.
#
# Endast:
#
#      ~/.ssh/id_ed25519.pub
#
# ska läggas till på GitHub.
#
# ============================================================
