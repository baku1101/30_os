; naskfunc
; TAB=4

[FORMAT "WCOFF"]				; オブジェクトファイルを作るモード
[INSTRSET "i486p"]				; 486の命令まで使いたいという記述
[BITS 32]						; 32ビットモード用の機械語を作らせる
[FILE "naskfunc.nas"]			; ソースファイル名情報

		GLOBAL	_io_hlt, _io_cli, _io_sti, _io_stihlt
		GLOBAL	_io_in8,  _io_in16,  _io_in32
		GLOBAL	_io_out8, _io_out16, _io_out32
		GLOBAL	_io_load_eflags, _io_store_eflags
		GLOBAL	_load_gdtr, _load_idtr
		GLOBAL	_asm_inthandler21, _asm_inthandler27, _asm_inthandler2c
		EXTERN	_inthandler21, _inthandler27, _inthandler2c    ;EXTERNは他のソースにある関数の呼び出し(これはint.cにある)

[SECTION .text]

_io_hlt:	; void io_hlt(void); 命令の停止，割り込みとかで再開
		HLT
		RET

_io_cli:	; void io_cli(void); ハードウェア割り込み禁止 IF(interrupt flag)をクリア
		CLI
		RET

_io_sti:	; void io_sti(void); ハードウェア割り込み許可
		STI
		RET

_io_stihlt:	; void io_stihlt(void);
		STI
		HLT
		RET

_io_in8:	; int io_in8(int port);
		MOV		EDX,[ESP+4]		; portアドレスの設定
		MOV		EAX,0
		IN		AL,DX 			; portから入力されたデータがALに格納，DXがポートアドレス
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
		OUT		DX,AL			; DXが出力ポート,ALにデータが入っている
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
		PUSHFD		; PUSH EFLAGS という意味(スタックにeflagsを入れる)
		POP		EAX ; スタックの一番上(eflags)をpopしてEAXに代入
		RET

_io_store_eflags:	; void io_store_eflags(int eflags);
		MOV		EAX,[ESP+4]
		PUSH	EAX
		POPFD		; POP EFLAGS という意味
		RET

_load_gdtr:		; void load_gdtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX      ; LGDTは"48bit分(つまり6byte分)読み取ってGDTRに代入する"命令で，そのままだと8byte(DWORD*2)でオーバーするからESP+6にlimitを代入する
		LGDT	[ESP+6]         ; GDTレジスタ:GDTが始まるアドレスとGDTのサイズを格納
		RET

_load_idtr:		; void load_idtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LIDT	[ESP+6]
		RET

_asm_inthandler21:    ; 割り込み処理は，レジスタの値をスタックに退避させてから実行
		PUSH	ES
		PUSH	DS
		PUSHAD                ; 諸々のレジスタ(8個)をスタックにpushするやつ
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS   ;SS=DS=ESになるように(同じセグメントを指すように)する
		MOV		DS,AX   ;(こうしないとC言語的にまずいらしい)
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

; もう使っていない
; _write_mem8:	; void write_mem8(int addr, int data);
; 		MOV		ECX,[ESP+4]		; [ESP+4]にaddrが入っているのでそれをECXに読み込む
; 		MOV		AL,[ESP+8]		; [ESP+8]にdataが入っているのでそれをALに読み込む
; 		MOV		[ECX],AL
; 		RET
