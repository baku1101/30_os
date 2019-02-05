; haribote-os
; tab=4

;BOOT_INFO�֌W,��������ꏊ�̐ݒ�
CYLS	EQU		0x0ff0			; �u�[�g�Z�N�^���ݒ肷��
LEDS	EQU		0x0ff1
VMODE	EQU 	0x0ff2			; �F���Ɋւ�����D���r�b�g�J���[��?
SCRNX	EQU 	0x0ff4			; �𑜓x��X(screen x)
SCRNY	EQU 	0x0ff6			; �𑜓x��Y(screen y)
VRAM	EQU 	0x0ff8			; �O���t�B�b�N�o�b�t�@�̊J�n�Ԓn

		ORG		0xc200			; ���̃v���O�������ǂ��ɓǂݍ��܂��̂�(�X�^�b�N�|�C���^�ɂ��ꂪ����?)

		MOV		AL,0x013		; VGA�O���t�B�b�N�X,320x200x8bit�J���[
		MOV		AH,0x00
		INT		0x10
		MOV 	BYTE [VMODE],8	; ��ʃ��[�h����������
		MOV 	WORD [SCRNX],320
		MOV 	WORD [SCRNY],200
		MOV 	DWORD [VRAM],0x000a0000 ; ��ʗp�̃�����(video RAM), �Ԓn����ʏ�̉�f�ɑΉ�

; �L�[�{�[�h��LED��Ԃ�BIOS�ɋ����Ă��炤
		MOV 	AH,0x02
		INT 	0x16 			; keyboard BIOS
		MOV 	[LEDS],AL


fin:
		HLT						; ��������܂�CPU���~������(halt)
		JMP		fin				; �������[�v
