; KERNEL.asm
org 8000h
jmp setup_game 
VIDMEM       equ 0B800h
SCREENW      equ 80
SCREENH      equ 25
BGCOLOR      equ 2020h
APPLECOLOR   equ 4020h
SNAKECOLOR   equ 5020h
TIMER        equ 046Ch
SNAKEXARRAY  equ 1000h
SNAKEYARRAY  equ 2000h
UP           equ 0
DOWN         equ 1
LEFT         equ 2
RIGHT        equ 3
playerX:     dw 40
playerY:     dw 12
appleX:      dw 16
appleY:      dw 12
direction:   db 4
snakeLength: dw 1

setup_game:
    mov ax, 0003h
    int 10h
    mov ax, VIDMEM
    mov es, ax
    mov ax, [playerX]
    mov word [SNAKEXARRAY], ax
    mov ax, [playerY]
    mov word [SNAKEYARRAY], ax
    mov ah, 02h
    mov dx, 2600h
    int 10h

game_loop:
    mov ax, BGCOLOR
    xor di, di
    mov cx, SCREENW*SCREENH
    rep stosw
    xor bx, bx
    mov cx, [snakeLength]
    mov ax, SNAKECOLOR

.snake_loop:
    imul di, [SNAKEYARRAY+bx], SCREENW*2
    imul dx, [SNAKEXARRAY+bx], 2
    add di, dx
    stosw
    inc bx
    inc bx
    loop .snake_loop
    imul di, [appleY], SCREENW*2
    imul dx, [appleX], 2
    add di, dx
    mov ax, APPLECOLOR
    stosw
    mov al, [direction]
    mov si, [playerX]
    mov di, [playerY]
    cmp al, UP
    je move_up
    cmp al, DOWN
    je move_down
    cmp al, LEFT
    je move_left
    cmp al, RIGHT
    je move_right
    jmp update_snake

move_up:
    dec di
    jmp update_snake

move_down:
    inc di
    jmp update_snake

move_left:
    dec si
    jmp update_snake

move_right:
    inc si

update_snake:
    mov word [playerX], si
    mov word [playerY], di
    imul bx, [snakeLength], 2

.snake_loop:
    mov ax, [SNAKEXARRAY-2+bx]
    mov word [SNAKEXARRAY+bx], ax
    mov ax, [SNAKEYARRAY-2+bx]
    mov word [SNAKEYARRAY+bx], ax
    dec bx
    dec bx
    jnz .snake_loop
    mov word [SNAKEXARRAY], si
    mov word [SNAKEYARRAY], di
    cmp di, -1
    je game_lost
    cmp di, SCREENH
    je game_lost
    cmp si, -1
    je game_lost
    cmp si, SCREENW
    je game_lost
    cmp word [snakeLength], 1
    je get_player_input
    mov bx, 2
    mov cx, [snakeLength]

check_hit_snake_loop:
    cmp si, [SNAKEXARRAY+bx]
    jne .increment
    cmp di, [SNAKEYARRAY+bx]
    je game_lost

.increment:
    inc bx
    inc bx
    loop check_hit_snake_loop

get_player_input:
    mov bl, [direction]
    mov ah, 1
    int 16h
    jz check_apple
    xor ah, ah
    int 16h
    cmp al, 'w'
    je w_pressed
    cmp al, 's'
    je s_pressed
    cmp al, 'a'
    je a_pressed
    cmp al, 'd'
    je d_pressed
    cmp al, 'r'
    je r_pressed
    cmp al, 0x0D       ; Enter key
    je pause_game
    jmp check_apple

w_pressed:
    cmp byte [direction], DOWN
    je check_apple              ; stop up if going down
    mov bl, UP
    jmp check_apple

s_pressed:
    cmp byte [direction], UP
    je check_apple              ; stop down if going up
    mov bl, DOWN
    jmp check_apple

a_pressed:
    cmp byte [direction], RIGHT
    je check_apple              ; stop left if going right
    mov bl, LEFT
    jmp check_apple
    
d_pressed:
    cmp byte [direction], LEFT
    je check_apple              ; stop right if going left
    mov bl, RIGHT
    jmp check_apple

r_pressed:
    int 19h
pause_game:
    ; show the "PAUSED" message
    mov dword [ES:0x0000], 1F411F50h  ; "PA"
    mov dword [ES:0x0004], 1F531F55h  ; "US"
    mov dword [ES:0x0008], 1F441F45h  ; "ED"
.wait_unpause:
    mov ah, 1
    int 16h
    jz .wait_unpause
    xor ah, ah
    int 16h
    cmp al, 0x0D       ; wait for ENTER to unpause
    jne .wait_unpause
    jmp game_loop      ; resume game

check_apple:
    mov byte [direction], bl
    mov ax, si
    cmp ax, [appleX]
    jne delay_loop
    mov ax, di
    cmp ax, [appleY]
    jne delay_loop
    inc word [snakeLength]

next_apple:
    ;; random X position
    xor ah, ah
    int 1Ah
    mov ax, dx
    xor dx, dx
    mov cx, SCREENW
    div cx
    mov word [appleX], dx
    ;; random Y position
    xor ah, ah
    int 1Ah
    mov ax, dx
    xor dx, dx
    mov cx, SCREENH
    div cx
    mov word [appleY], dx
    xor bx, bx
    mov cx, [snakeLength]

.check_loop:
    mov ax, [appleX]
    cmp ax, [SNAKEXARRAY+bx]
    jne .increment2
    mov ax, [appleY]
    cmp ax, [SNAKEYARRAY+bx]
    je next_apple

.increment2:
    inc bx
    inc bx
    loop .check_loop

delay_loop:
    mov bx, [TIMER]
    inc bx
    inc bx
    
.delay:
    cmp [TIMER], bx
    jl .delay
    jmp game_loop

game_lost:
    mov dword [ES:0000], 1F4F1F4Ch
    mov dword [ES:0004], 1F451F53h

reset:
    xor ah, ah
    int 16h
    int 19h