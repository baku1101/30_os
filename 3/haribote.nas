; haribote-os
; tab=4

;BOOT_INFO関係,メモする場所の設定
CYLS	EQU		0x0ff0			; ブートセクタが設定する
LEDS	EQU		0x0ff1
VMODE	EQU 	0x0ff2			; 色数に関する情報．何ビットカラーか?
SCRNX	EQU 	0x0ff4			; 解像度のX(screen x)
SCRNY	EQU 	0x0ff6			; 解像度のY(screen y)
VRAM	EQU 	0x0ff8			; グラフィックバッファの開始番地

		ORG		0xc200			; このプログラムがどこに読み込まれるのか(スタックポインタにこれが入る?)

		MOV		AL,0x013		; VGAグラフィックス,320x200x8bitカラー
		MOV		AH,0x00
		INT		0x10
		MOV 	BYTE [VMODE],8	; 画面モードをメモする
		MOV 	WORD [SCRNX],320
		MOV 	WORD [SCRNY],200
		MOV 	DWORD [VRAM],0x000a0000 ; 画面用のメモリ(video RAM), 番地が画面上の画素に対応

; キーボードのLED状態をBIOSに教えてもらう
		MOV 	AH,0x02
		INT 	0x16 			; keyboard BIOS
		MOV 	[LEDS],AL


fin:
		HLT						; 何かあるまでCPUを停止させる(halt)
		JMP		fin				; 無限ループ
