
# デフォルト動作

default :
	make img

# ファイル生成規則

ipl.bin : ipl.nas Makefile
	./nask.exe ipl.nas ipl.bin ipl.lst

helloos.img : ipl.bin Makefile
	./edimg.exe   imgin:./fdimg0at.tek wbinimg src:ipl.bin len:512 from:0 to:0   imgout:helloos.img

# コマンド

asm :
	make -r ipl.bin

img :
	make -r helloos.img

run :
	make img
	qemu-system-i386 helloos.img

install :
	make img
	../z_tools/imgtol.com w a: helloos.img

clean :
	-del ipl.bin
	-del ipl.lst

src_only :
	make clean
	-del helloos.img
