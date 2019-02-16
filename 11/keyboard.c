/* キーボード関係 */

#include "bootpack.h"

struct FIFO8 keyfifo;

void inthandler21(int *esp)
{
	unsigned char data;
	io_out8(PIC0_OCW2, 0x61);	/* IRQ-01受付完了をPICに通知 */
	data = io_in8(PORT_KEYDAT);
	fifo8_put(&keyfifo, data);
	return;
}

#define PORT_KEYSTA				0x0064
#define KEYSTA_SEND_NOTREADY	0x02
#define KEYCMD_WRITE_MODE		0x60
#define KBC_MODE				0x47

void wait_KBC_sendready(void) //KBC:キーボード制御回路
{
	/* キーボードコントローラがデータ送信可能になるのを待つ */
	for (;;) {
		if ((io_in8(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0) { //装置番号PORT_KEYSTAからきたデータの2番目
			break;
		}
	}
	return;
}

void init_keyboard(void)
{
	/* キーボードコントローラの初期化 */
	wait_KBC_sendready();
	io_out8(PORT_KEYCMD, KEYCMD_WRITE_MODE); //KEYCMD_WRITE_MODE:モード設定コマンド,次の書き込みでモード指定設定
	wait_KBC_sendready();
	io_out8(PORT_KEYDAT, KBC_MODE); // マウス利用モードになる(CPUに割り込み命令を出すようになる)
	return;
}
