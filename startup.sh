#!/bin/bash

# Make sure your custom glibc is used only by your app
export LD_LIBRARY_PATH=/home/site/wwwroot/lib:$LD_LIBRARY_PATH

# export PYTHONPATH=$PYTHONPATH:"/home/site/wwwroot/venv/lib/site-packages"
source /home/site/wwwroot/venv/bin/activate

# Log glibc version for verification
/home/site/wwwroot/lib/ld-linux-x86-64.so.2 \
    --library-path /home/site/wwwroot/lib \
    /home/site/wwwroot/lib/libc.so.6 > /home/site/wwwroot/daphne-log.txt 2>&1

# Start the ASGI server using daphne
# daphne -b 0.0.0.0 -p 8000 myproject.asgi:application >> /home/site/wwwroot/daphne-log.txt 2>&1
gunicorn myapp.wsgi:application --bind 0.0.0.0:8000 --workers 3 --timeout 600