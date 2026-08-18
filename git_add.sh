#!/bin/bash

# Add git access so youre able to push to github


sudo apt update
sudo apt install git

git --version

git config --global user.name "Skruvfejs"
git config --global user.email "johan.m.harwell@gmailcom"

git config --list

ssh-keygen -t ed25519 -C "johan.m.harwell@gmail.com"


eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_ed25519

cat ~/.ssh/id_ed25519.pub

# Kopiera hela raden från filen

echo "Lägg in nyckeln på GitHub\n"
echo "Gå till: https://github.com/settings/keys"

echo "Klicka New SSH key\n"
echo "Titel: t.ex. Linux Mint PC\n"
echo "Klistra in nyckeln\”"
echo "Klicka Add SSH key\n"
echo "\n"
read -p "Tryck Enter för att fortsätta..."

# Testa anslutningen på din dator:
ssh -T git@github.com

# Första gången frågar den: "Are you sure you want to continue connecting?"
# Skriv: yes

# Lyckat resultat:
# Hi dittanvändarnamn! You've successfully authenticated...


# Ändra till ssh istället för user/pass,, det fungear inte med github längre, det är depricated
# Nu behöver bara ditt repo använda SSH istället för HTTPS.

# Gå in i det repot du vill "ansluta med ssh"
cd ~/Projects/linux_stuff

# Kolla vad du har innan:
git remote -v

# Öndra till ssh, här ändrar du Skruvfejs/repo-name. behåll .git
git remote set-url origin git@github.com:skruvfejs/linux_stuff.git

# Kolla vad du har nu
git remote -v

# Du ska få nånting i stil med:
# origin  git@github.com:skruvfejs/linux_stuff.git (fetch)
# origin  git@github.com:skruvfejs/linux_stuff.git (push)


# Pusha ditt projekt
# git push

