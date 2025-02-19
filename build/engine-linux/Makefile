#
# Linux (and FreeBSD/NetBSD)
#

include ../common.mk

#
# Toolchain selection
#

CC = cc

#
# CPPFLAGS
#

CPPFLAGS = \
	-I./libroot/include \
	-I./libroot/include/freetype2  \
	-I/usr/local/include \
	-I/usr/pkg/include \
	-I/usr/X11R7/include

#
# CFLAGS
#

CFLAGS = \
	-O0 -g3 \
	-ffast-math \
	-ftree-vectorize \
	-std=gnu11 \
	-Wall \
	-Werror \
	-Wextra \
	-Wundef \
	-Wconversion \
	-Wno-multichar

#
# LDFLAGS
#

LDFLAGS = \
	-L./libroot/lib \
	-Wl,-dn,-lpng16,-ljpeg,-lwebp,-lfreetype,-lvorbisfile,-lvorbis,-logg,-lz,-lbz2,-dy \
	-Wl,--gc-sections \
	-L/usr/local/lib \
	-L/usr/pkg/lib \
	-lasound \
	-L/usr/X11R7/lib \
	-lX11 \
	-lXpm \
	-lGL \
	-lGLX \
	-lpthread \
	-lm

#
# Source files
#

SRCS_LINUX = \
	../../src/linux/asound.c \
	../../src/linux/gstplay.c \
	../../src/linux/x11main.c

SRCS_KHRONOS = \
	../../src/khronos/glrender.c

HDRS = \
	../../src/khronos/glrender.h \
	../../src/linux/asound.h \
	../../src/linux/gstplay.h

#
# .c.o compilation rules
#

OBJS = \
	$(SRCS_KHRONOS:../../src/khronos/%.c=%.o) \
	$(SRCS_LINUX:../../src/linux/%.c=%.o) \
	$(SRCS_MAIN:../../src/%.c=%.o)

%.o: ../../src/khronos/%.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $<

%.o: ../../src/linux/%.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) `pkg-config --cflags gstreamer-1.0 gstreamer-video-1.0` $<

%.o: ../../src/%.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $<

#
# Target
#

all: suika

suika: libroot $(OBJS) $(HDRS) $(HDRS_MAIN)
	$(CC) -o suika $(OBJS) $(LDFLAGS) `pkg-config --libs gstreamer-1.0 gstreamer-video-1.0`

libroot:
	./build-libs.sh

#
# Phony
#

install: suika
	cp suika ../../suika-linux

clean:
	rm -rf *~ *.o suika log.txt sav tmp

erase:
	rm -rf *~ *.o suika log.txt sav tmp libroot

lines:
	cat ../../src/*.[ch] ../../src/microsoft/* ../../src/apple/* ../../src/google/* ../../src/khronos/* | wc -l
	grep -E '/\*|\*/|^([ \t]+\*)' ../../src/*.[cm] | wc -l
	grep 'assert' ../../src/*.[chm] | wc -l

gcc-analyze:
	gcc $(CPPFLAGS) -fanalyzer -finput-charset=utf-8 `pkg-config --cflags gstreamer-1.0 gstreamer-video-1.0` -c $(SRCS) $(SRCS_MAIN)

clang-analyze:
	clang $(CPPFLAGS) --analyze -finput-charset=utf-8 `pkg-config --cflags gstreamer-1.0 gstreamer-video-1.0` -c $(SRCS) $(SRCS_MAIN)

valgrind:
	cp -R ../../game/demo ./demo
	cd demo && valgrind --leak-check=full ./suika && cd ..
	rm -rf demo
