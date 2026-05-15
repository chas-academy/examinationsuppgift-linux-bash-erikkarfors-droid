#!/bin/bash

# måste köras som root

if [ "$EUID" -ne 0 ]; then
    echo "Fel: Scriptet måste köras som root."
    exit 1
fi

# minst en användare

if [ "$#" -lt 1 ]; then
    echo "Användning: $0 användare1 användare2..."
    exit 1
fi

# skapa alla användare först

for username in "$@"; do

    # skapa användare

    useradd -m "$username"

    # skapa katalogstruktur

    mkdir -p "/home/$username/Documents"
    mkdir -p "/home/$username/Downloads"
    mkdir -p "/home/$username/Work"

    # endast ägarrättigheter

    chown "$username:$username" "/home/$username/Documents"
    chown "$username:$username" "/home/$username/Downloads"
    chown "$username:$username" "/home/$username/Work"

    chmod 700 "/home/$username/Documents"
    chmod 700 "/home/$username/Downloads"
    chmod 700 "/home/$username/Work"

done

# skapa welcome.txt efter att ALLA användare finns

for username in "$@"; do

    # skapa welcome.txt

    echo "Välkommen $username" > "/home/$username/welcome.txt"

    echo "Andra användare i systemet:" >> "/home/$username/welcome.txt"

    cut -d: -f1 /etc/passwd >> "/home/$username/welcome.txt"

done

echo "Klart!"
