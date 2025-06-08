#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing GLIBC 2.34 (if needed)"
apt-get update -y
apt-get install -y make build-essential gawk bison
wget http://ftp.gnu.org/gnu/libc/glibc-2.34.tar.gz
tar -xzf glibc-2.34.tar.gz
mkdir glibc-build
cd glibc-build
echo "********************************************** downloaded glibc 2.34"

../glibc-2.34/configure --prefix=$HOME/glibc-2.34
make -j$(nproc)
make install

echo "********************************************** isntalled glibc 2.34"
cp -r ~/glibc-2.34/lib /home/site/wwwroot


export LD_LIBRARY_PATH=/home/site/wwwroot:$LD_LIBRARY_PATH

echo "********************************************** ld lib path"
echo ${LD_LIBRARY_PATH}

echo "Activating virtualenv"
source venv/bin/activate

# Start with Daphne instead of Gunicorn
exec daphne -b 0.0.0.0 -p 8000 myproject.asgi:application

echo $LD_LIBRARY_PATH


# echo "Activating virtualenv"
# source venv/bin/activate

# echo ">>> setting LD_LIBRARY_PATH and Starting Gunicorn server"
# export LD_LIBRARY_PATH="$GLIBC_PREFIX/lib:$LD_LIBRARY_PATH"
# echo $LD_LIBRARY_PATH
# gunicorn myapp.wsgi --bind=0.0.0.0:${PORT:-8000}
