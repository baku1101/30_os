; naskfunc
; TAB=4

[FORMAT "WCOFF"]				; �I�u�W�F�N�g�t�@�C������郂�[�h
[INSTRSET "i486p"]				; 486�̖��߂܂Ŏg�������Ƃ����L�q
[BITS 32]						; 32�r�b�g���[�h�p�̋@�B�����点��
[FILE "naskfunc.nas"]			; �\�[�X�t�@�C�������

		GLOBAL	_io_hlt, _io_cli, _io_sti, _io_stihlt
		GLOBAL	_io_in8,  _io_in16,  _io_in32
		GLOBAL	_io_out8, _io_out16, _io_out32
		GLOBAL	_io_load_eflags, _io_store_eflags
		GLOBAL	_load_gdtr, _load_idtr
		GLOBAL	_asm_inthandler21, _asm_inthandler27, _asm_inthandler2c
		EXTERN	_inthandler21, _inthandler27, _inthandler2c    ;EXTERN�͑��̃\�[�X�ɂ���֐��̌Ăяo��(�����int.c�ɂ���)

[SECTION .text]

_io_hlt:	; void io_hlt(void); ���߂̒�~�C���荞�݂Ƃ��ōĊJ
		HLT
		RET

_io_cli:	; void io_cli(void); �n�[�h�E�F�A���荞�݋֎~ IF(interrupt flag)���N���A
		CLI
		RET

_io_sti:	; void io_sti(void); �n�[�h�E�F�A���荞�݋���
		STI
		RET

_io_stihlt:	; void io_stihlt(void);
		STI
		HLT
		RET

_io_in8:	; int io_in8(int port);
		MOV		EDX,[ESP+4]		; port�A�h���X�̐ݒ�
		MOV		EAX,0
		IN		AL,DX 			; port������͂��ꂽ�f�[�^��AL�Ɋi�[�CDX���|�[�g�A�h���X
		RET

_io_in16:	; int io_in16(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AX,DX
		RET

_io_in32:	; int io_in32(int port);
		MOV		EDX,[ESP+4]		; port
		IN		EAX,DX
		RET

_io_out8:	; void io_out8(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		AL,[ESP+8]		; data
		OUT		DX,AL			; DX���o�̓|�[�g,AL�Ƀf�[�^�������Ă���
		RET

_io_out16:	; void io_out16(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,AX
		RET

_io_out32:	; void io_out32(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,EAX
		RET

_io_load_eflags:	; int io_load_eflags(void);
		PUSHFD		; PUSH EFLAGS �Ƃ����Ӗ�(�X�^�b�N��eflags������)
		POP		EAX ; �X�^�b�N�̈�ԏ�(eflags)��pop����EAX�ɑ��
		RET

_io_store_eflags:	; void io_store_eflags(int eflags);
		MOV		EAX,[ESP+4]
		PUSH	EAX
		POPFD		; POP EFLAGS �Ƃ����Ӗ�
		RET

_load_gdtr:		; void load_gdtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX      ; LGDT��"48bit��(�܂�6byte��)�ǂݎ����GDTR�ɑ������"���߂ŁC���̂܂܂���8byte(DWORD*2)�ŃI�[�o�[���邩��ESP+6��limit��������
		LGDT	[ESP+6]         ; GDT���W�X�^:GDT���n�܂�A�h���X��GDT�̃T�C�Y���i�[
		RET

_load_idtr:		; void load_idtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LIDT	[ESP+6]
		RET

_asm_inthandler21:    ; ���荞�ݏ����́C���W�X�^�̒l���X�^�b�N�ɑޔ������Ă�����s
		PUSH	ES
		PUSH	DS
		PUSHAD                ; ���X�̃��W�X�^(8��)���X�^�b�N��push������
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS   ;SS=DS=ES�ɂȂ�悤��(�����Z�O�����g���w���悤��)����
		MOV		DS,AX   ;(�������Ȃ���C����I�ɂ܂����炵��)
		MOV		ES,AX   ;
		CALL	_inthandler21
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

_asm_inthandler27:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler27
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

_asm_inthandler2c:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler2c
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

; �����g���Ă��Ȃ�
; _write_mem8:	; void write_mem8(int addr, int data);
; 		MOV		ECX,[ESP+4]		; [ESP+4]��addr�������Ă���̂ł����ECX�ɓǂݍ���
; 		MOV		AL,[ESP+8]		; [ESP+8]��data�������Ă���̂ł����AL�ɓǂݍ���
; 		MOV		[ECX],AL
; 		RET
