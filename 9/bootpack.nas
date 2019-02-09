[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_init_gdtidt
	EXTERN	_init_pic
	EXTERN	_io_sti
	EXTERN	_keyfifo
	EXTERN	_fifo8_init
	EXTERN	_mousefifo
	EXTERN	_io_out8
	EXTERN	_init_keyboard
	EXTERN	_enable_mouse
	EXTERN	_init_palette
	EXTERN	_init_screen8
	EXTERN	_init_mouse_cursor8
	EXTERN	_putblock8_8
	EXTERN	_sprintf
	EXTERN	_putfonts8_asc
	EXTERN	_io_cli
	EXTERN	_fifo8_status
	EXTERN	_fifo8_get
	EXTERN	_mouse_decode
	EXTERN	_boxfill8
	EXTERN	_io_stihlt
	EXTERN	_io_load_eflags
	EXTERN	_io_store_eflags
	EXTERN	_memtest_sub
	EXTERN	_load_cr0
	EXTERN	_store_cr0
[FILE "bootpack.c"]
[SECTION .data]
LC0:
	DB	"(%d, %d)",0x00
LC1:
	DB	"memory %dMB   free : %dKB",0x00
LC3:
	DB	"[lcr %4d %4d]",0x00
LC4:
	DB	"(%3d, %3d)",0x00
LC2:
	DB	"%02X",0x00
[SECTION .text]
	GLOBAL	_HariMain
_HariMain:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	MOV	EBX,2
	SUB	ESP,488
	CALL	_init_gdtidt
	CALL	_init_pic
	CALL	_io_sti
	LEA	EAX,DWORD [-348+EBP]
	PUSH	EAX
	PUSH	32
	PUSH	_keyfifo
	CALL	_fifo8_init
	LEA	EAX,DWORD [-476+EBP]
	PUSH	EAX
	PUSH	128
	PUSH	_mousefifo
	CALL	_fifo8_init
	PUSH	249
	PUSH	33
	CALL	_io_out8
	ADD	ESP,32
	PUSH	239
	PUSH	161
	CALL	_io_out8
	CALL	_init_keyboard
	LEA	EAX,DWORD [-492+EBP]
	PUSH	EAX
	CALL	_enable_mouse
	PUSH	-1073741825
	PUSH	4194304
	CALL	_memtest
	PUSH	3932160
	MOV	ESI,EAX
	CALL	_memman_init
	PUSH	647168
	PUSH	4096
	PUSH	3932160
	CALL	_memman_free
	LEA	EAX,DWORD [-4194304+ESI]
	SHR	ESI,20
	ADD	ESP,36
	PUSH	EAX
	PUSH	4194304
	PUSH	3932160
	CALL	_memman_free
	CALL	_init_palette
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_init_screen8
	MOVSX	EAX,WORD [4084]
	LEA	ECX,DWORD [-16+EAX]
	MOV	EAX,ECX
	CDQ
	IDIV	EBX
	MOV	DWORD [-496+EBP],EAX
	MOVSX	EAX,WORD [4086]
	PUSH	14
	LEA	ECX,DWORD [-44+EAX]
	MOV	EAX,ECX
	CDQ
	IDIV	EBX
	LEA	EBX,DWORD [-316+EBP]
	MOV	EDI,EAX
	PUSH	EBX
	CALL	_init_mouse_cursor8
	ADD	ESP,32
	PUSH	16
	PUSH	EBX
	LEA	EBX,DWORD [-60+EBP]
	PUSH	EDI
	PUSH	DWORD [-496+EBP]
	PUSH	16
	PUSH	16
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putblock8_8
	ADD	ESP,32
	PUSH	EDI
	PUSH	DWORD [-496+EBP]
	PUSH	LC0
	PUSH	EBX
	CALL	_sprintf
	PUSH	EBX
	PUSH	7
	PUSH	0
	PUSH	0
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putfonts8_asc
	ADD	ESP,40
	PUSH	3932160
	CALL	_memman_total
	SHR	EAX,10
	MOV	DWORD [ESP],EAX
	PUSH	ESI
	PUSH	LC1
	PUSH	EBX
	CALL	_sprintf
	PUSH	EBX
	PUSH	7
	PUSH	32
	PUSH	0
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putfonts8_asc
	ADD	ESP,40
L2:
	CALL	_io_cli
	PUSH	_keyfifo
	CALL	_fifo8_status
	PUSH	_mousefifo
	MOV	EBX,EAX
	CALL	_fifo8_status
	LEA	EAX,DWORD [EAX+EBX*1]
	POP	EBX
	POP	ESI
	TEST	EAX,EAX
	JE	L18
	PUSH	_keyfifo
	CALL	_fifo8_status
	POP	ECX
	TEST	EAX,EAX
	JNE	L19
	PUSH	_mousefifo
	CALL	_fifo8_status
	POP	EDX
	TEST	EAX,EAX
	JE	L2
	PUSH	_mousefifo
	CALL	_fifo8_get
	MOV	EBX,EAX
	CALL	_io_sti
	MOVZX	EAX,BL
	PUSH	EAX
	LEA	EAX,DWORD [-492+EBP]
	PUSH	EAX
	CALL	_mouse_decode
	ADD	ESP,12
	TEST	EAX,EAX
	JE	L2
	PUSH	DWORD [-484+EBP]
	PUSH	DWORD [-488+EBP]
	PUSH	LC3
	LEA	EBX,DWORD [-60+EBP]
	PUSH	EBX
	CALL	_sprintf
	ADD	ESP,16
	MOV	EAX,DWORD [-480+EBP]
	TEST	EAX,1
	JE	L11
	MOV	BYTE [-59+EBP],76
L11:
	TEST	EAX,2
	JE	L12
	MOV	BYTE [-57+EBP],82
L12:
	AND	EAX,4
	JE	L13
	MOV	BYTE [-58+EBP],67
L13:
	PUSH	31
	PUSH	151
	PUSH	16
	PUSH	32
	PUSH	14
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_boxfill8
	PUSH	EBX
	PUSH	7
	PUSH	16
	PUSH	32
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putfonts8_asc
	LEA	EAX,DWORD [15+EDI]
	ADD	ESP,52
	PUSH	EAX
	MOV	EAX,DWORD [-496+EBP]
	ADD	EAX,15
	PUSH	EAX
	PUSH	EDI
	PUSH	DWORD [-496+EBP]
	PUSH	14
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_boxfill8
	MOV	EAX,DWORD [-488+EBP]
	ADD	EDI,DWORD [-484+EBP]
	ADD	ESP,28
	ADD	DWORD [-496+EBP],EAX
	JS	L20
L14:
	TEST	EDI,EDI
	JS	L21
L15:
	MOVSX	EAX,WORD [4084]
	SUB	EAX,16
	CMP	DWORD [-496+EBP],EAX
	JLE	L16
	MOV	DWORD [-496+EBP],EAX
L16:
	MOVSX	EAX,WORD [4086]
	SUB	EAX,16
	CMP	EDI,EAX
	JLE	L17
	MOV	EDI,EAX
L17:
	PUSH	EDI
	PUSH	DWORD [-496+EBP]
	PUSH	LC4
	PUSH	EBX
	CALL	_sprintf
	PUSH	15
	PUSH	79
	PUSH	0
	PUSH	0
	PUSH	14
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_boxfill8
	ADD	ESP,44
	PUSH	EBX
	PUSH	7
	PUSH	0
	PUSH	0
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putfonts8_asc
	LEA	EAX,DWORD [-316+EBP]
	PUSH	16
	PUSH	EAX
	PUSH	EDI
	PUSH	DWORD [-496+EBP]
	PUSH	16
	PUSH	16
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putblock8_8
	ADD	ESP,56
	JMP	L2
L21:
	XOR	EDI,EDI
	JMP	L15
L20:
	MOV	DWORD [-496+EBP],0
	JMP	L14
L19:
	PUSH	_keyfifo
	CALL	_fifo8_get
	MOV	EBX,EAX
	CALL	_io_sti
	PUSH	EBX
	LEA	EBX,DWORD [-60+EBP]
	PUSH	LC2
	PUSH	EBX
	CALL	_sprintf
	PUSH	31
	PUSH	15
	PUSH	16
	PUSH	0
	PUSH	14
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_boxfill8
	ADD	ESP,44
	PUSH	EBX
	PUSH	7
	PUSH	16
	PUSH	0
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_putfonts8_asc
	ADD	ESP,24
	JMP	L2
L18:
	CALL	_io_stihlt
	JMP	L2
	GLOBAL	_memtest
_memtest:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	ESI
	PUSH	EBX
	XOR	ESI,ESI
	CALL	_io_load_eflags
	OR	EAX,262144
	PUSH	EAX
	CALL	_io_store_eflags
	CALL	_io_load_eflags
	POP	EDX
	TEST	EAX,262144
	JE	L23
	MOV	ESI,1
L23:
	AND	EAX,-262145
	PUSH	EAX
	CALL	_io_store_eflags
	MOV	EAX,ESI
	POP	EBX
	TEST	AL,AL
	JNE	L26
L24:
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_memtest_sub
	MOV	EBX,EAX
	POP	EAX
	MOV	EAX,ESI
	POP	EDX
	TEST	AL,AL
	JNE	L27
L25:
	LEA	ESP,DWORD [-8+EBP]
	MOV	EAX,EBX
	POP	EBX
	POP	ESI
	POP	EBP
	RET
L27:
	CALL	_load_cr0
	AND	EAX,-1610612737
	PUSH	EAX
	CALL	_store_cr0
	POP	EAX
	JMP	L25
L26:
	CALL	_load_cr0
	OR	EAX,1610612736
	PUSH	EAX
	CALL	_store_cr0
	POP	ECX
	JMP	L24
	GLOBAL	_memman_init
_memman_init:
	PUSH	EBP
	MOV	EBP,ESP
	MOV	EAX,DWORD [8+EBP]
	MOV	DWORD [EAX],0
	MOV	DWORD [4+EAX],0
	MOV	DWORD [8+EAX],0
	MOV	DWORD [12+EAX],0
	POP	EBP
	RET
	GLOBAL	_memman_total
_memman_total:
	PUSH	EBP
	XOR	EAX,EAX
	MOV	EBP,ESP
	XOR	EDX,EDX
	PUSH	EBX
	MOV	EBX,DWORD [8+EBP]
	MOV	ECX,DWORD [EBX]
	CMP	EAX,ECX
	JAE	L36
L34:
	ADD	EAX,DWORD [20+EBX+EDX*8]
	INC	EDX
	CMP	EDX,ECX
	JB	L34
L36:
	POP	EBX
	POP	EBP
	RET
	GLOBAL	_memman_alloc
_memman_alloc:
	PUSH	EBP
	XOR	ECX,ECX
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	MOV	ESI,DWORD [12+EBP]
	MOV	EBX,DWORD [8+EBP]
	MOV	EAX,DWORD [EBX]
	CMP	ECX,EAX
	JAE	L51
L49:
	MOV	EDX,DWORD [20+EBX+ECX*8]
	CMP	EDX,ESI
	JAE	L53
	INC	ECX
	CMP	ECX,EAX
	JB	L49
L51:
	XOR	EAX,EAX
L37:
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
L53:
	MOV	EDI,DWORD [16+EBX+ECX*8]
	LEA	EAX,DWORD [ESI+EDI*1]
	MOV	DWORD [16+EBX+ECX*8],EAX
	MOV	EAX,EDX
	SUB	EAX,ESI
	MOV	DWORD [20+EBX+ECX*8],EAX
	TEST	EAX,EAX
	JNE	L43
	MOV	EAX,DWORD [EBX]
	DEC	EAX
	MOV	DWORD [EBX],EAX
	CMP	ECX,EAX
	JAE	L43
	MOV	ESI,EAX
L48:
	MOV	EAX,DWORD [24+EBX+ECX*8]
	MOV	EDX,DWORD [28+EBX+ECX*8]
	MOV	DWORD [16+EBX+ECX*8],EAX
	MOV	DWORD [20+EBX+ECX*8],EDX
	INC	ECX
	CMP	ECX,ESI
	JB	L48
L43:
	MOV	EAX,EDI
	JMP	L37
	GLOBAL	_memman_free
_memman_free:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	MOV	ESI,DWORD [8+EBP]
	PUSH	EBX
	XOR	EBX,EBX
	MOV	EDI,DWORD [ESI]
	CMP	EBX,EDI
	JGE	L56
L60:
	MOV	EAX,DWORD [12+EBP]
	CMP	DWORD [16+ESI+EBX*8],EAX
	JA	L56
	INC	EBX
	CMP	EBX,EDI
	JL	L60
L56:
	TEST	EBX,EBX
	JLE	L61
	MOV	EDX,DWORD [12+ESI+EBX*8]
	MOV	EAX,DWORD [8+ESI+EBX*8]
	ADD	EAX,EDX
	CMP	EAX,DWORD [12+EBP]
	JE	L84
L61:
	CMP	EBX,EDI
	JGE	L70
	MOV	EAX,DWORD [12+EBP]
	ADD	EAX,DWORD [16+EBP]
	CMP	EAX,DWORD [16+ESI+EBX*8]
	JE	L85
L70:
	CMP	EDI,4089
	JG	L72
	MOV	ECX,EDI
	CMP	EDI,EBX
	JLE	L82
L77:
	MOV	EAX,DWORD [8+ESI+ECX*8]
	MOV	EDX,DWORD [12+ESI+ECX*8]
	MOV	DWORD [16+ESI+ECX*8],EAX
	MOV	DWORD [20+ESI+ECX*8],EDX
	DEC	ECX
	CMP	ECX,EBX
	JG	L77
L82:
	LEA	EAX,DWORD [1+EDI]
	MOV	DWORD [ESI],EAX
	CMP	DWORD [4+ESI],EAX
	JGE	L78
	MOV	DWORD [4+ESI],EAX
L78:
	MOV	EAX,DWORD [12+EBP]
	MOV	DWORD [16+ESI+EBX*8],EAX
	MOV	EAX,DWORD [16+EBP]
	MOV	DWORD [20+ESI+EBX*8],EAX
L83:
	XOR	EAX,EAX
L54:
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
L72:
	MOV	EAX,DWORD [16+EBP]
	INC	DWORD [12+ESI]
	ADD	DWORD [8+ESI],EAX
	OR	EAX,-1
	JMP	L54
L85:
	MOV	EAX,DWORD [12+EBP]
	MOV	DWORD [16+ESI+EBX*8],EAX
	MOV	EAX,DWORD [16+EBP]
	ADD	DWORD [20+ESI+EBX*8],EAX
	JMP	L83
L84:
	ADD	EDX,DWORD [16+EBP]
	MOV	DWORD [12+ESI+EBX*8],EDX
	CMP	EBX,DWORD [ESI]
	JGE	L83
	MOV	EAX,DWORD [12+EBP]
	ADD	EAX,DWORD [16+EBP]
	CMP	EAX,DWORD [16+ESI+EBX*8]
	JNE	L83
	ADD	EDX,DWORD [20+ESI+EBX*8]
	MOV	DWORD [12+ESI+EBX*8],EDX
	MOV	EAX,DWORD [ESI]
	DEC	EAX
	MOV	DWORD [ESI],EAX
	CMP	EBX,EAX
	JGE	L83
	MOV	ECX,EAX
L69:
	MOV	EAX,DWORD [24+ESI+EBX*8]
	MOV	EDX,DWORD [28+ESI+EBX*8]
	MOV	DWORD [16+ESI+EBX*8],EAX
	MOV	DWORD [20+ESI+EBX*8],EDX
	INC	EBX
	CMP	EBX,ECX
	JL	L69
	JMP	L83