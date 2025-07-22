#!/usr/bin/env bash
set -e

USB_DEV="/dev/sdb"  # change this if needed

echo "[*] building SnakeOS..."
./build.sh

echo "[*] nuking existing partition tables on $USB_DEV..."
sudo wipefs --all --force "$USB_DEV"
sudo sgdisk --zap-all "$USB_DEV"

echo "[*] zeroing first 10 MiB of $USB_DEV..."
sudo dd if=/dev/zero of="$USB_DEV" bs=1M count=10 status=progress conv=fsync

echo "[*] writing os.img to $USB_DEV..."
sudo dd if=out/os.img of="$USB_DEV" bs=512 status=progress conv=fsync

echo "[*] syncing..."
sync

echo "[✔] USB is clean and flashed. Remove other drives and boot!"
