#!/bin/bash

# Daftar user email
USERS=("angling" "cemara" "brama" "damar" "minak")

for user in "${USERS[@]}"; do
    # Cek apakah user sudah ada, kalau tidak buat
    if id "$user" &>/dev/null; then
        echo "User $user sudah ada"
    else
        echo "Membuat user $user..."
        sudo useradd -m -s /bin/bash "$user"
        sudo passwd "$user"
    fi

    # Pastikan folder home ada
    HOME_DIR="/home/$user"
    if [ ! -d "$HOME_DIR" ]; then
        echo "Membuat folder home $HOME_DIR..."
        sudo mkdir -p "$HOME_DIR"
    fi

    # Set ownership dan permission
    sudo chown -R "$user:$user" "$HOME_DIR"
    sudo chmod 700 "$HOME_DIR"

    # Buat Maildir jika belum ada
    if [ ! -d "$HOME_DIR/Maildir" ]; then
        echo "Membuat Maildir untuk $user..."
        sudo -u "$user" /usr/bin/maildirmake.dovecot "$HOME_DIR/Maildir"
        sudo chmod -R 700 "$HOME_DIR/Maildir"
    fi
done

# Restart Dovecot
echo "Merestart Dovecot..."
sudo systemctl restart dovecot

echo "Selesai! Semua user email sekarang harus bisa login IMAP."
