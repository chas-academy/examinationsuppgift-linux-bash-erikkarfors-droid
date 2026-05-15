#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: Scriptet måste köras som root."
    exit 1
fi

# Kontrollera att minst en användare skickas med
if [ "$#" -lt 1 ]; then
    echo "Användning: $0 användare1 användare2 ..."
    exit 1
fi

# Loopa igenom alla användare
for username in "$@"; do

    # Skapa användaren med hemkatalog
    useradd -m "$username"

    # Sökväg till hemkatalog
    home_dir="/home/$username"

    # Skapa undermappar
    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # Sätt ägare
    chown "$username:$username" "$home_dir/Documents"
    chown "$username:$username" "$home_dir/Downloads"
    chown "$username:$username" "$home_dir/Work"

    # Endast ägaren ska ha åtkomst
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapa welcome.txt
    welcome_file="$home_dir/welcome.txt"

    echo "Välkommen $username" > "$welcome_file"

    # Lista alla andra användare
    cut -d: -f1 /etc/passwd | grep -v "^$username$" >> "$welcome_file"

    # Sätt ägare och rättigheter på filen
    chown "$username:$username" "$welcome_file"
    chmod 600 "$welcome_file"

    echo "Användare $username skapad."

done

echo "Klart!"
