org 0x7C00 ;set origin to that

bits 16 ; 16 bit real mode

start:
    jmp main

; bootloader stuff

main:
	xor ax, ax           ;setting up data segment to 0x0000
	mov ds, ax
	mov es, ax
	
	mov si, startupmsg   ;print msg on startup
	call printstr
	
	mov si, newline	 ;move cursor to the next line
	call printstr
	
	mov si, prompt  ;print prompt msg
	call printstr
	
	call getchar	  ;read char from keyboard
	
	mov si, newline	 ;move cursor to the next line
	call printstr
	
	mov si, echo	;print the char that was entered
	call printstr
	
	mov al, [char]	 ;load the character
	call putchar	 ;print the character
	
	jmp $			   ;loop


;print null-terminated string
printstr:
	lodsb			  ;load next char
	or al, al		  ;check for null
	jz endprintstr ;if null, done
	
	call putchar	  ;print char
	jmp printstr	  ;repeat

endprintstr:
    ret ;return

;print char in AL
putchar:
	mov ah, 0x0E	  ;set teletype mode
	int 0x10		  ;BIOS print

	ret				  ;return

;read char to AL
getchar:
	mov ah, 1h		  ;wait for key
	int 0x16		  ;BIOS read
	jz getchar		  ;retry if no key
	mov byte [char], al  ;store the char

	ret				  ;return

;data
startupmsg db "TEST TEST TEST TEST", 0
prompt db "type something > ", 0
echo db "you entered: ", 0
newline db 0x0D, 0x0A, 0	 ;new line
char db 0x00, 0			 ;character

times 510-($-$$) db 0	 ;pad to 510 bytes
dw 0xAA55			     ;boot signature
