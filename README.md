# snakeOS

snakeOS is an operating system that does exactly one thing:
Play Snake.

Written in pure x86 Assembly and designed to run in 16 bit real mode. Cream gravy.



## Requirements

* `nasm` (for assembling)
* `qemu` (for emulation)
* `dd` (for writing to USB)
* A USB stick
* A machine that can boot in legacy BIOS mode



## Installation & Running

### Emulation

1. Run the build script:

   ```bash
   ./build.sh
   ```

2. Boot with QEMU:

   ```bash
   qemu-system-i386 -drive format=raw,file=out/os.img,index=0,if=floppy
   ```



### Real Hardware

1. Flash to USB:

   ```bash
   sudo dd if=out/os.img of=/dev/sdX bs=512 conv=fsync
   ```

   > Remember to replace `/dev/sdX` with your actual USB device. Please be careful.

2. Reboot your PC and boot from USB in legacy BIOS mode (disable UEFI if needed).




## Controls

* `W` `A` `S` `D` - You know what this does.
* `R` - Reset
