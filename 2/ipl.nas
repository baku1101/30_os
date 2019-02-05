; hello-os
; TAB=4

		ORG		0x7c00			; ���̃v���O�������ǂ��ɓǂݍ��܂��̂�(�X�^�b�N�|�C���^�ɂ��ꂪ����?)
								; �u�[�g�Z�N�^�̗̈悪�ǂ�����ǂݏo����邩�͌��܂��Ă���(0�Ԓn�Ƃ�0xf0000�t�߂�BIOS���g�p)
								; http://oswiki.osask.jp/?%28AT%29memorymap ���Q��

; �ȉ��͕W���I��FAT12�t�H�[�}�b�g�t���b�s�[�f�B�X�N�̂��߂̋L�q

		JMP		entry			; JMP 0x7c50�Ɠ��`�Dentry�̂悤�ȃ��x���̓A�h���X���w��
		DB		0x90
		DB		"HELLOIPL"		; �u�[�g�Z�N�^�̖��O�����R�ɏ����Ă悢�i8�o�C�g�j
		DW		512				; 1�Z�N�^�̑傫���i512�ɂ��Ȃ���΂����Ȃ��j
		DB		1				; �N���X�^�̑傫���i1�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
		DW		1				; FAT���ǂ�����n�܂邩�i���ʂ�1�Z�N�^�ڂ���ɂ���j
		DB		2				; FAT�̌��i2�ɂ��Ȃ���΂����Ȃ��j
		DW		224				; ���[�g�f�B���N�g���̈�̑傫���i���ʂ�224�G���g���ɂ���j
		DW		2880			; ���̃h���C�u�̑傫���i2880�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
		DB		0xf0			; ���f�B�A�̃^�C�v�i0xf0�ɂ��Ȃ���΂����Ȃ��j
		DW		9				; FAT�̈�̒����i9�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
		DW		18				; 1�g���b�N�ɂ����̃Z�N�^�����邩�i18�ɂ��Ȃ���΂����Ȃ��j
		DW		2				; �w�b�h�̐��i2�ɂ��Ȃ���΂����Ȃ��j
		DD		0				; �p�[�e�B�V�������g���ĂȂ��̂ł����͕K��0
		DD		2880			; ���̃h���C�u�傫����������x����
		DB		0,0,0x29		; �悭�킩��Ȃ����ǂ��̒l�ɂ��Ă����Ƃ����炵��
		DD		0xffffffff		; ���Ԃ�{�����[���V���A���ԍ�
		DB		"HELLO-OS   "	; �f�B�X�N�̖��O�i11�o�C�g�j
		DB		"FAT12   "		; �t�H�[�}�b�g�̖��O�i8�o�C�g�j
		RESB	18				; �Ƃ肠����18�o�C�g�����Ă���

; �v���O�����{��

entry:
		MOV		AX,0			; ���W�X�^������(AX:16bit(2byte) register)
		MOV		SS,AX			; SS:�X�^�b�N�Z�O�����g,0�ŏ�����
		MOV		SP,0x7c00		; SP:�X�^�b�N�|�C���^,ORG�̒l�ŏ�����
		MOV		DS,AX			; DS:�f�[�^�Z�O�����g,0�ŏ�����
		MOV		ES,AX			; ES:�G�N�X�g���Z�O�����g,0�ŏ�����

		MOV		SI,msg			; SI:source index,msg���x���̎w���A�h���X����(0x7c74)
putloop:
		MOV		AL,[SI]			; []������'������'�̈Ӗ��ɂȂ�(SI�Ԓn�̒l��ǂݏo��(\n,\n,...)
								; �{����BYTE[SI]�Ƃ���K�v�����邪�CAL��1byte������ÖٓI�ɂ������߂����
		ADD		SI,1			; SI��1�𑫂�(���̔Ԓn��,)
		CMP		AL,0			; AL��0 == msg��ǂ݂�����
		JE		fin				; JE:jump if equal
		MOV		AH,0x0e			; �ꕶ���\���t�@���N�V����
		MOV		BX,15			; �J���[�R�[�h
		INT		0x10			; �r�f�IBIOS�Ăяo��(INT:interrupt(���荞��))
								; BIOS:basic input output system,���ROM�ɂ��炩���ߏ������܂�Ă���
								; INT��BIOS�̊֐����ĂԂ��߂̖���(�����0x10�Ԗڂ̖��߂��Ăяo���Ă���)
		JMP		putloop
fin:
		HLT						; ��������܂�CPU���~������(halt)
		JMP		fin				; �������[�v

msg:
		DB		0x0a, 0x0a		; ���s��2��
		DB		"hello, world"
		DB		0x0a			; ���s
		DB		0

		RESB	0x7dfe-$		; 0x7dfe�܂ł�0x00�Ŗ��߂閽��

		DB		0x55, 0xaa

