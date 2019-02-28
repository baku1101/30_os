; ipl
; TAB=4

CYLS	EQU		10				; どこまで読み込むか

		ORG		0x7c00			; このプログラムがメモリ上のどこに読み込まれるのか
								;ブートセクタの領域がどこから読み出されるかは決まっている(0番地とか0xf0000付近はBIOSが使用)
								; http://oswiki.osask.jp/?%28AT%29memorymap を参照

; 以下は標準的なFAT12フォーマットフロッピーディスクのための記述

		JMP		entry			; JMP 0x7c50と同義．entryのようなラベルはアドレスを指す
		DB		0x90
		DB		"HARIBOTE"		; ブートセクタの名前を自由に書いてよい（8バイト）
		DW		512				; 1セクタの大きさ（512にしなければいけない）
		DB		1				; クラスタの大きさ（1セクタにしなければいけない）
		DW		1				; FATがどこから始まるか（普通は1セクタ目からにする）
		DB		2				; FATの個数（2にしなければいけない）
		DW		224				; ルートディレクトリ領域の大きさ（普通は224エントリにする）
		DW		2880			; このドライブの大きさ（2880セクタにしなければいけない）
		DB		0xf0			; メディアのタイプ（0xf0にしなければいけない）
		DW		9				; FAT領域の長さ（9セクタにしなければいけない）
		DW		18				; 1トラックにいくつのセクタがあるか（18にしなければいけない）
		DW		2				; ヘッドの数（2にしなければいけない）
		DD		0				; パーティションを使ってないのでここは必ず0
		DD		2880			; このドライブ大きさをもう一度書く
		DB		0,0,0x29		; よくわからないけどこの値にしておくといいらしい
		DD		0xffffffff		; たぶんボリュームシリアル番号
		DB		"HARIBOTEOS "	; ディスクの名前（11バイト）
		DB		"FAT12   "		; フォーマットの名前（8バイト）
		RESB	18				; とりあえず18バイトあけておく

; プログラム本体

entry:
		MOV		AX,0			; レジスタ初期化(AX:16bit(2byte) register)
		MOV		SS,AX			; SS:スタックセグメント,0で初期化
		MOV		SP,0x7c00		; SP:スタックポインタ,ORGの値で初期化
		MOV		DS,AX			; DS:データセグメント,0で初期化

; ディスクを読む
	; ディスク読み込みに必要なデータのセット
		MOV		AX,0x0820
		MOV		ES,AX			; ES,BXを合わせた32bitでメモリ上のどこに読み込むかを指定
								; アドレス: ES*16 + BX
		MOV		CH,0			; シリンダ0 (フロッピーのどこから読むか)
		MOV		DH,0			; ヘッド0 (フロッピーの裏表どちらを読むか)
		MOV		CL,2			; セクタ2 (シリンダ内のどのセクタ(512byte)を読み出すか)

readloop:
		MOV		SI,0			; 失敗回数を数えるレジスタ

retry:
		MOV		AH,0x02			; AH=0x02 : ディスク読み込み
		MOV		AL,1			; 1セクタ
		MOV		BX,0
		MOV		DL,0x00			; Aドライブ(ドライブ番号:0)
	; ディスク読み込み
		INT		0x13			; ディスクBIOS呼び出し
								; INT = 0x13の時，AH = 0x02ならばディスク読み込み
								; 戻り値でCF(carry flag) = 1 ならエラー
	;	JC		error			; JC:jump if carry,エラーならerrorラベルに飛ぶ
		JNC		next			; jump if not carry
		ADD 	SI,1			; SI++
		CMP 	SI,5			; SI == 5 ?
		JAE		error 			; jump if above or equal SI >= 5 だったらerrorに飛ぶ
		MOV 	AH,0x00
		MOV 	DL,0x00
		INT 	0x13 			; ドライブのリセット (AH=0,DL=0でシステムのリセット)
		JMP 	retry

next:
		MOV 	AX,ES 			; アドレスを0x200(512:1セクタ)進める
		ADD 	AX,0x0020
		MOV 	ES,AX 			; add ES,0x020がないからこう書いている
		ADD 	CL,1			; CL++
		CMP 	CL,18
		JBE		readloop 		; jump if below or equal CL <= 18 だったらreadloopに飛ぶ(18セクタまでループ)
		MOV 	CL,1
		ADD 	DH,1
		CMP 	DH,2
		JB 		readloop 		; DH < 2だったらreadloopに飛ぶ
		MOV 	DH,0
		ADD 	CH,1
		CMP 	CH,CYLS
		JB 		readloop 		; CH < CYLS(総シリンダー数)だったらreadloopに飛ぶ

; ブートセクタを読み切ったからOS部分の起動をする
		MOV		[0x0ff0],CH		; IPLがどこまで読んだのかをメモ
		JMP		0xc200

; ここからはエラー処理
error:
		MOV		SI,msg
putloop:
		MOV		AL,[SI]			; []がつくと'メモリ'の意味になる(SI番地の値を読み出す(\n,\n,...)
								; 本当はBYTE[SI]とする必要があるが，ALが1byteだから暗黙的にそう解釈される
		ADD		SI,1			; SIに1を足す(次の番地へ,)
		CMP		AL,0			; ALが0 == msgを読みきった
		JE		fin				; JE:jump if equal
		MOV		AH,0x0e			; 一文字表示ファンクション
		MOV		BX,15			; カラーコード
		INT		0x10			; ビデオBIOS呼び出し(INT:interrupt(割り込み))
								; BIOS:basic input output system,基板のROMにあらかじめ書き込まれてある
								; INTはBIOSの関数を呼ぶための命令(今回は0x10番目の命令を呼び出している)
		JMP		putloop
fin:
		HLT						; 何かあるまでCPUを停止させる(halt)
		JMP		fin				; 無限ループ
msg:
		DB		0x0a, 0x0a		; 改行を2つ
		DB		"load error"
		DB		0x0a			; 改行
		DB		0

		RESB	0x7dfe-$		; 0x7dfeまでを0x00で埋める命令

		DB		0x55, 0xaa

