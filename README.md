Here's an updated version of your `README.md` for **snakeOS**, cleaned up with clearer formatting, proper sections, and placeholder commands filled in where appropriate:

---

# snakeOS

snakeOS is an operating system that does exactly one thing:
**Play Snake.**
Written in pure x86 Assembly and designed to run in 16 bit real mode.

---

## Requirements

* `nasm` (for assembling)
* `qemu` (for emulation)
* `dd` (for writing to USB)
* A USB stick
* A machine that can boot in legacy BIOS mode

---

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

---

### Real Hardware

1. Flash to USB:

   ```bash
   sudo dd if=out/os.img of=/dev/sdX bs=512 conv=fsync
   ```

   > Replace `/dev/sdX` with your actual USB device. Please be careful.

2. Reboot your PC and boot from USB in legacy BIOS mode (disable UEFI if needed).

---

## Controls

* `W` `A` `S` `D` — Move
* `R` — Reset
* First to reach the goal wins. Don't crash into yourself.

---

## Notes

* Built to be extremely minimal. There are no BIOS extensions, no input buffering. just Snake.

---

Let me know if you want a version with screenshots, a badge, or GitHub Actions build status.
