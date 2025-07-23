#!/usr/bin/env bash
set -e
KERNEL_SECTORS=30

mkdir -p out
nasm -f bin src/boot.asm -o out/boot.bin
nasm -f bin src/kernel.asm -o out/kernel.bin
boot_size=$(stat -c%s out/boot.bin)
kernel_size=$(stat -c%s out/kernel.bin)
max_kernel_size=$((512 * KERNEL_SECTORS))
#padding
pad_bytes=$((max_kernel_size - kernel_size))
dd if=/dev/zero bs=1 count=$pad_bytes >> out/kernel.bin 2>/dev/null
cat out/boot.bin out/kernel.bin > out/os.img
echo "built os.img"
