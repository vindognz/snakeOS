org 0x7C00
bits 16

start:
    cli
    xor ax,ax
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov sp,0x7C00
    sti

    mov [bootdrv], dl

    mov si, loading_msg

.print_char:
    lodsb
    or al,al
    jz .done_print
    mov ah,0x0E
    int 0x10
    jmp .print_char
    
.done_print:

    mov ax, 0x0000
    mov es, ax
    mov bx, 0x8000

    mov ah, 0x02
    mov al, SECTORS
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [bootdrv]
    int 0x13
    jc disk_error

    jmp 0x0000:0x8000

disk_error:
    mov si, error_msg
    jmp .err_loop

.err_loop:
    lodsb
    or al,al
    jz .err_loop
    mov ah,0x0E
    int 0x10
    jmp .err_loop

SECTORS       equ 30
loading_msg   db "Loading kernel...",0
error_msg     db "Disk read error!",0
bootdrv       db 0

times 510-($-$$) db 0
dw 0xAA55