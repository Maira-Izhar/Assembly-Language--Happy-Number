[org 0x0100]

mov ax,0xB800
mov es,ax
mov ax,0
mov di,0

clear: push ax
push di
push cx
mov ax,0xB800
mov es,ax
mov di,0
mov ax,0x0720
mov cx,2000
cld
rep stosw
pop cx
pop di
pop ax

;**********GET INPUT************

mov ax,0
mov bx,0
mov ah,0		; get first digit
int 16h
sub al,0x30
mov ah,0
mov cx,10
mul cx
mov bx,ax


mov ah,0		; get second digit
int 16h
sub al,0x30
mov ah,0
add bx,ax
mov ax,bx
mov cx,10
mul cx
mov bx,ax

mov ah,0		; get third digit
int 16h
sub al,0x30
mov ah,0
add bx,ax
mov ax,bx
mov cx,10
mul cx
mov bx,ax

mov ah,0		; get fourth digit
int 16h
sub al,0x30
mov ah,0
add bx,ax

;***********START CALCULATING**************

mov [number],bx		; start calculating
mov bx,0
mov cx,256
mov dx,4
jmp nextloop

next_iteration:		; outer loop
mov dx,4
cmp word [sum],1
je happyy
mov ax,[sum]
mov [number],ax
mov word [sum],0 

nextloop:		; inner loop

mov bl,10
mov ax,[number]
div bl
mov bh,ah
mov ah, 0
mov word[number],ax
mov al,bh
mov ah,0x00
mul bh
add [sum],ax
;dec dx
;cmp dx,0
;jne nextloop
cmp word [number],0
je next_iteration
loop nextloop

cmp word [sum],1
je happyy
jne not_happy

;*************PRINT HAPPY/UNHAPPY*************

happyy:mov ax,160
push ax
mov ax,0
push ax
mov ax,0x07
push ax
mov ax,happy
push ax
call printstr
jmp end

not_happy: mov ax,160
push ax
mov ax,0
push ax
mov ax,0x07
push ax
mov ax,nothappy
push ax
call printstr
jmp end


printstr:
push bp
mov bp,sp
push es
push ax
push cx
push si
push di

push ds
pop es
mov di,[bp+4]
mov cx,0xffff
xor al,al
repne scasb
mov ax,0xffff
sub ax,cx
dec ax
jz exit

mov cx,ax
mov ax,0xB800
mov es,ax
mov al,80

mul byte [bp+8]
add ax,[bp+10]
shl ax,1
mov di,ax
mov si,[bp+4]
mov ah,[bp+6]

cld
nextchar1:
lodsb
stosw
loop nextchar1

exit:
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 8



end: mov ax,0x4C00
int 21h
number: dw 0
sum: dw 0
happy: db 'Happy',0
nothappy: db 'UnHappy',0
