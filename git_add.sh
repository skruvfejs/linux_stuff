#!/bin/bash
# Add git access so youre able to push to github


# CONFIGURATION
# ---------------
EMAIL="skruvfejs@mail.com"
USER="Skruvfejs"
REPOPATH="$HOME/Projects/linux_stuff"




# Starting...
sudo apt update
sudo apt install git

git --version

git config --global user.name $USER
git config --global user.email $EMAIL

git config --list

ssh-keygen -t ed25519 -C $EMAIL


eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_ed25519

echo -e "Din nyckel är: \n"
cat ~/.ssh/id_ed25519.pub

# Kopiera hela raden från filen

echo -e "\n"
echo -e "Lägg in nyckeln på GitHub\n"
echo -e "---------------------------"
echo -e "Gå till: https://github.com/settings/keys"
echo -e "\n"
echo -e "Klicka New SSH key\n"
echo -e "Titel: t.ex. Linux Mint PC\n"
echo -e "Klistra in nyckeln\”"
echo -e "Klicka Add SSH key\n"
echo -e "\n"
read -p "Tryck Enter för att fortsätta när du lagt in nyckeln på github..."

# Testa anslutningen på din dator:
echo -e "Testar anslutningen:\n"
ssh -T git@github.com

# Ändra till ssh istället för user/pass,, det fungear inte med github längre, det är depricated
# Nu behöver bara ditt repo använda SSH istället för HTTPS.

# Gå in i det repot du vill "ansluta med ssh"
cd "$REPOPATH" || exit 1

# Kolla vad du har innan:
git remote -v

# Ändra till ssh för just detta repot
echo -e "Ändrar så github använder ssh för anslutning"
git remote set-url origin "git@github.com:${USER}/$(basename "$REPOPATH").git"


# Kolla vad du har nu
git remote -v

# Du ska få nånting i stil med:
# origin  git@github.com:skruvfejs/linux_stuff.git (fetch)
# origin  git@github.com:skruvfejs/linux_stuff.git (push)


# Pusha ditt projekt
echo -e "Klar!\n"
echo -e "\n"
echo -e "Nu kan du använda:\n" 
echo -e "git add <file> eller . \n"
echo -e "git commit -m ''my comment''\n"
echo -e "git push\n"



