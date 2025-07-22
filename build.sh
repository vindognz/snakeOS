#!/usr/bin/env bash
set -e

# Set to match %define SECTORS in boot.asm
KERNEL_SECTORS=30

mkdir -p out

# Assemble bootloader and kernel
nasm -f bin src/boot.asm -o out/boot.bin
nasm -f bin src/kernel.asm -o out/kernel.bin

# Verify boot.bin size
boot_size=$(stat -c%s out/boot.bin)
if [ "$boot_size" -ne 512 ]; then
  echo "ERROR: boot.bin must be exactly 512 bytes! Got $boot_size." >&2
  exit 1
fi

# Calculate and check kernel size
kernel_size=$(stat -c%s out/kernel.bin)
max_kernel_size=$((512 * KERNEL_SECTORS))

if [ "$kernel_size" -gt "$max_kernel_size" ]; then
  echo "ERROR: kernel.bin is larger than allocated size ($KERNEL_SECTORS sectors = $max_kernel_size bytes)!" >&2
  exit 1
fi

# Pad kernel to full sector count
pad_bytes=$((max_kernel_size - kernel_size))
dd if=/dev/zero bs=1 count=$pad_bytes >> out/kernel.bin 2>/dev/null

# Combine bootloader + kernel into final image
cat out/boot.bin out/kernel.bin > out/os.img

# Report
echo "Built out/os.img ($(stat -c%s out/os.img) bytes)"
