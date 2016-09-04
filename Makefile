default: myos.bin

ASM=i686-none-elf-as
CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra
CC=i686-none-elf-gcc

boot.o: boot.s
	$(ASM) boot.s -o boot.o

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o

myos.bin: kernel.o boot.o linker.ld
	$(CC) -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o

myos.iso: myos.bin grub.cfg
	mkdir -p isodir/boot/grub
	cp myos.bin isodir/boot/myos.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir
	rm -rf isodir

run: myos.iso
	qemu-system-i386 -cdrom myos.iso -curses

clean:
	rm -rf isodir *.o *.iso *.bin *~
