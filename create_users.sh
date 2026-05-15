#!/bin/bash

# rootkontroll

if [ $EUID -ne 0 ]; then
    echo "Måste köras som root"
    exit 1
fi

# loopa genom användare

for username in "$@"
do

    # skapa användare

    useradd -m "$username"

    # skapa mappar

    mkdir /home/"$username"/Documents
    mkdir /home/"$username"/Downloads
    mkdir /home/"$username"/Work

    # rättigheter

    chmod 700 /home/"$username"/Documents
    chmod 700 /home/"$username"/Downloads
    chmod 700 /home/"$username"/Work

    # welcome.txt

    echo "Välkommen $username" > /home/"$username"/welcome.txt

    cut -d: -f1 /etc/passwd >> /home/"$username"/welcome.txt

done
