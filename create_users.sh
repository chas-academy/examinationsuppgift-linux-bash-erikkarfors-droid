#!/bin/bash

# Kontrollera att scriptet körs som root
if [ "$EUID" -ne 0 ]; then
    echo "Fel: Scriptet måste köras som root."
    exit 1
fi

# Kontrollera att minst en användare skickas in
if [ "$#" -lt 1 ]; then
    echo "Användning: $0 användare1 användare2 ..."
    exit 1
fi

# Loopa igenom alla användare
for username in "$@"; do

    # Skapa användare och grupp
    useradd -m -U "$username"

    # Hemkatalog
    home_dir="/home/$username"

    # Skapa mappar
    mkdir "$home_dir/Documents"
    mkdir "$home_dir/Downloads"
    mkdir "$home_dir/Work"

    # Sätt ägare
    chown "$username:$username" "$home_dir/Documents"
    chown "$username:$username" "$home_dir/Downloads"
    chown "$username:$username" "$home_dir/Work"

    # Endast ägare får läsa/skriva
    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # Skapa welcome.txt
    echo "Välkommen $username" > "$home_dir/welcome.txt"

    # Lista andra användare
    cut -d: -f1 /etc/passwd | grep -v "^$username$" >> "$home_dir/welcome.txt"

    # Ägare och rättigheter för filen
    chown "$username:$username" "$home_dir/welcome.txt"
    chmod 600 "$home_dir/welcome.txt"

done

echo "Klart!"


