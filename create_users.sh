#!/bin/bash

# måste köras som root

if [ "$EUID" -ne 0 ]; then
    echo "Fel: Scriptet måste köras som root."
    exit 1
fi

# minst en användare

if [ "$#" -lt 1 ]; then
    echo "Användning: $0 användare1 användare 2..."
    exit 1
fi

# hämta lista på befintliga användare

existing_users=$(cut -d: -f1 /etc/passwd)

# loopa igenom alla argument

for username in "$@"; do
    # kontrollera om användaren redan finns
    useradd -m "$username"

    # skapa katalogstruktur
    home_dir="/home/$username"

    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    #endast ägarrättigheter
    chown -R "$username:$username" "$home_dir"
    chmod -R 700 "$home_dir"

    #skapa welcome.txt
    welcome_file="$home_dir/welcome.txt"

    echo "Välkommen $username" > "$welcome_file"
    echo "" >>"$welcome_file"
    echo "Andra användare i systemet:" >> "$welcome_file"
    echo "$existing_users" >> "$welcome_file"

    # sätt ägare och rättigheter på filen
    chown "$username:$username" "$welcome_file"
    chmod 600 "$welcome_file"
    
    echo "Användare $username skapad."
done 


echo "Klart!"
