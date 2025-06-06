#!/bin/bash
set -e

echo ">>> Installing GLIBC 2.34 (if needed)"
GLIBC_VERSION="2.34"
GLIBC_PREFIX="$HOME/glibc"
mkdir -p $GLIBC_PREFIX
cd /tmp

curl -sSL http://ftp.gnu.org/gnu/libc/glibc-$GLIBC_VERSION.tar.gz | tar zx
cd glibc-$GLIBC_VERSION

mkdir build && cd build
../configure --prefix=$GLIBC_PREFIX
make -j$(nproc)
make install

echo "Activating virtualenv"
source venv/bin/activate

echo ">>> setting LD_LIBRARY_PATH and Starting Gunicorn server"
export LD_LIBRARY_PATH="$GLIBC_PREFIX/lib:$LD_LIBRARY_PATH"
echo $LD_LIBRARY_PATH
gunicorn myapp.wsgi --bind=0.0.0.0:${PORT:-8000}
