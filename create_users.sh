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

# loopa igenom alla argument

for username in "$@"; do

    # kontrollera om användaren redan finns

    if ! id "$username" &>/dev/null; then
        useradd -m "$username"
    fi

    # skapa katalogstruktur

    home_dir=$(eval echo "~$username")

    mkdir -p "$home_dir/Documents"
    mkdir -p "$home_dir/Downloads"
    mkdir -p "$home_dir/Work"

    # endast ägarrättigheter

    chown "$username:$username" "$home_dir/Documents"
    chown "$username:$username" "$home_dir/Downloads"
    chown "$username:$username" "$home_dir/Work"

    chmod 700 "$home_dir/Documents"
    chmod 700 "$home_dir/Downloads"
    chmod 700 "$home_dir/Work"

    # skapa welcome.txt

    welcome_file="$home_dir/welcome.txt"

    echo "Välkommen $username" > "$welcome_file"

    echo "Andra användare i systemet:" >> "$welcome_file"

    cut -d: -f1 /etc/passwd | grep -v "^$username$" >> "$welcome_file"

    # sätt ägare och rättigheter på filen

    chown "$username:$username" "$welcome_file"
    chmod 600 "$welcome_file"

    echo "Användare $username skapad."

done

echo "Klart!"
