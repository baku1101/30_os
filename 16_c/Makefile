OBJS_BOOTPACK = bootpack.obj naskfunc.obj hankaku.obj graphic.obj dsctbl.obj int.obj fifo.obj keyboard.obj mouse.obj memory.obj sheet.obj timer.obj mtask.obj

TOOLPATH = ../z_tools/
INCPATH  = $(TOOLPATH)/haribote/

MAKE     = $(TOOLPATH)make.exe -r
NASK     = $(TOOLPATH)nask.exe
CC1      = $(TOOLPATH)cc1.exe -I$(INCPATH) -Os -Wall -quiet
GAS2NASK = $(TOOLPATH)gas2nask.exe -a
OBJ2BIM  = $(TOOLPATH)obj2bim.exe
MAKEFONT = $(TOOLPATH)makefont.exe
BIN2OBJ  = $(TOOLPATH)bin2obj.exe
BIM2HRB  = $(TOOLPATH)bim2hrb.exe
RULEFILE = $(TOOLPATH)haribote/haribote.rul
EDIMG    = $(TOOLPATH)edimg.exe
IMGTOL   = $(TOOLPATH)imgtol.com
QEMU_DEBUG = -L . -m 32 -localtime -vga std -monitor stdio -s -S

# ƒfƒtƒHƒ‹ƒg“®ì

default :
	make img

# ƒtƒ@ƒCƒ‹¶¬‹K‘¥

ipl10.bin : ipl10.nas Makefile
	$(NASK) ipl10.nas ipl10.bin ipl10.lst

asmhead.bin : asmhead.nas Makefile
	$(NASK) asmhead.nas asmhead.bin asmhead.lst

hankaku.bin : hankaku.txt Makefile
	$(MAKEFONT) hankaku.txt hankaku.bin

hankaku.obj : hankaku.bin Makefile
	$(BIN2OBJ) hankaku.bin hankaku.obj _hankaku

bootpack.bim : $(OBJS_BOOTPACK) Makefile
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map $(OBJS_BOOTPACK)
# 3MB+64KB=3136KB

bootpack.hrb : bootpack.bim Makefile
	$(BIM2HRB) bootpack.bim bootpack.hrb 0

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys Makefile
	$(EDIMG)  imgin:./fdimg0at.tek wbinimg src:ipl10.bin len:512 from:0 to:0 copy from:haribote.sys to:@: imgout:haribote.img

# ˆê”Ê‹K‘¥
# —Dæ‡ˆÊ ¶¬‹K‘¥ > ˆê”Ê‹K‘¥

%.gas : %.c Makefile
	$(CC1) -o $*.gas $*.c

%.nas : %.gas Makefile
	$(GAS2NASK) $*.gas $*.nas

%.obj : %.nas Makefile
	$(NASK) $*.nas $*.obj $*.lst

# ƒRƒ}ƒ“ƒh

img :
	$(MAKE) haribote.img

run :
	$(MAKE) img
	qemu-system-i386 -fda haribote.img

debug :
	$(MAKE) img
	qemu-system-i386 -fda haribote.img $(QEMU_DEBUG)

install :
	$(MAKE) img
	$(IMGTOL) w a: haribote.img

clean :
	rm *.bin *.lst *.obj bootpack.map bootpack.hrb

src_only :
	$(MAKE) clean
	rm haribote.img
