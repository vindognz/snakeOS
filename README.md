# snakeOS

snakeOS is an operating system that does exactly one thing:
Play Snake.

Written in pure x86 Assembly and designed to run in 16 bit real mode. Cream gravy.



## requirements

* `nasm` (for assembling)
* `qemu` (for emulation)
* `dd` (for writing to usb)
* a usb stick
* a machine that can boot in legacy bios mode



## installation & running

### emulation

1. run the build script:

   ```bash
   ./build.sh
   ```

2. boot with qemu:

   ```bash
   qemu-system-i386 -drive format=raw,file=out/os.img,index=0,if=floppy
   ```



### real hardware

1. burn to usb:

   ```bash
   sudo dd if=out/os.img of=/dev/sdX bs=512 conv=fsync
   ```

   remember to replace `/dev/sdX` with your actual usb device lololol

2. reboot your computer and boot from usb in legacy bios mode (disable uefi if needed)




## controls

* `W` `A` `S` `D` - you know what this does
* `R` - reset
