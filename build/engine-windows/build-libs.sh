#!/bin/sh

set -eu

PREFIX=`pwd`/libroot

echo 'Reconstructing libroot...'
rm -rf tmp libroot
mkdir -p tmp libroot libroot/include libroot/lib
cd tmp

echo 'Building bzip2...'
tar xzf ../../libsrc/bzip2-1.0.6.tar.gz
cd bzip2-1.0.6
make libbz2.a PREFIX=i686-w64-mingw32- CFLAGS='-O3 -ffunction-sections -fdata-sections' CC=i686-w64-mingw32-gcc
cp bzlib.h ../../libroot/include/
cp libbz2.a ../../libroot/lib/
cd ..

echo 'Building libwebp...'
tar xzf ../../libsrc/libwebp-1.3.2.tar.gz
cd libwebp-1.3.2
./configure --prefix=$PREFIX --enable-static --disable-shared --host=i686-w64-mingw32 CPPFLAGS=-I$PREFIX/include CFLAGS='-O3 -ffunction-sections -fdata-sections' LDFLAGS=-L$PREFIX/lib CC=i686-w64-mingw32-gcc
make
make install
cd ..

echo 'Building zlib...'
tar xzf ../../libsrc/zlib-1.2.11.tar.gz
cd zlib-1.2.11
make -f win32/Makefile.gcc PREFIX=i686-w64-mingw32- CFLAGS='-O3 -ffunction-sections -fdata-sections'
cp zlib.h zconf.h ../../libroot/include/
cp libz.a ../../libroot/lib/
cd ..

echo 'Building libpng...'
tar xzf ../../libsrc/libpng-1.6.35.tar.gz
cd libpng-1.6.35
./configure --prefix=$PREFIX --enable-static --disable-shared --host=i686-w64-mingw32 CPPFLAGS=-I$PREFIX/include CFLAGS='-O3 -ffunction-sections -fdata-sections' LDFLAGS=-L$PREFIX/lib CC=i686-w64-mingw32-gcc
make
make install
cd ..

echo 'Building jpeg9...'
tar xzf ../../libsrc/jpegsrc.v9e.tar.gz
cd jpeg-9e
./configure --prefix=$PREFIX --enable-static --disable-shared --host=i686-w64-mingw32 CPPFLAGS=-I$PREFIX/include CFLAGS='-O3 -ffunction-sections -fdata-sections' LDFLAGS=-L$PREFIX/lib CC=i686-w64-mingw32-gcc
make
make install
cd ..

echo 'Building libogg...'
tar xzf ../../libsrc/libogg-1.3.3.tar.gz
cd libogg-1.3.3
./configure --prefix=$PREFIX --enable-static --disable-shared --host=i686-w64-mingw32 CFLAGS='-O3 -ffunction-sections -fdata-sections' CC=i686-w64-mingw32-gcc
make
make install
cd ..

echo 'Building libvorbis...'
tar xzf ../../libsrc/libvorbis-1.3.6.tar.gz
cd libvorbis-1.3.6
./configure --prefix=$PREFIX --enable-static --disable-shared --host=i686-w64-mingw32 PKG_CONFIG="" --with-ogg-includes=$PREFIX/include --with-ogg-libraries=$PREFIX/lib CFLAGS='-O3 -ffunction-sections -fdata-sections' CC=i686-w64-mingw32-gcc
make
make install
cd ..

echo 'Building freetyp2...'
tar xzf ../../libsrc/freetype-2.9.1.tar.gz
cd freetype-2.9.1
sed -e 's/FONT_MODULES += type1//' \
    -e 's/FONT_MODULES += cid//' \
    -e 's/FONT_MODULES += pfr//' \
    -e 's/FONT_MODULES += type42//' \
    -e 's/FONT_MODULES += pcf//' \
    -e 's/FONT_MODULES += bdf//' \
    -e 's/FONT_MODULES += pshinter//' \
    -e 's/FONT_MODULES += raster//' \
    -e 's/FONT_MODULES += psaux//' \
    -e 's/FONT_MODULES += psnames//' \
    < modules.cfg > modules.cfg.new
mv modules.cfg.new modules.cfg
# Add |tee for avoid freeze on Emacs shell.
./configure --enable-static --disable-shared --host=i686-w64-mingw32 --with-png=no --with-zlib=no --with-harfbuzz=no --with-bzip2=no --prefix=$PREFIX CFLAGS='-O3 -ffunction-sections -fdata-sections' CC=i686-w64-mingw32-gcc | tee
make | tee
make install | tee
cd ..

cd ..
rm -rf tmp

echo 'Finished.'
