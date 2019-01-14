#!/bin/bash

# this script flashes microSD from MacOS X with a specified image file.

# References that helped build this script:

# https://www.raspberrypi.org/documentation/installation/installing-images/linux.md
# http://elinux.org/RPi_Resize_Flash_Partitions

# Copyright 2019 Marc Blodeau

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

cat <<EOF

---------------------
MicroSD Flash Utility
---------------------

EOF

if [ "$(id -u)" != "0" ]; then
    cat <<EOF
ERROR: This script must be run as root .. Abort!

usage: sudo ./pi_flash_darwin.sh PATH/TO/IMG_FILE

The latest image can be downloaded from
https://www.raspberrypi.org/downloads/raspbian/ or
http://dietpi.com/

EOF
    exit
fi

if [ ! "$1" ]; then
    cat <<EOF
ERROR: image file not specified .. Abort!

usage: sudo ./pi_flash_darwin.sh PATH/TO/IMG_FILE

EOF
    exit
fi

if [ ! -f $1 ]; then
    cat <<EOF
ERROR: image file $1 not found .. Abort!

EOF
    exit
else
    echo -e "PASS: Image File is $1\n"
fi

while true; do
    cat <<EOF
This script assumes the microSD card is mounted to /dev/disk2

If this is the correct mount point, select Y to continue. Otherwise,
select N and update the script below to the appropriate mount point.

EOF

    read -p "Continue (y/n)? " yn
    case $yn in
	[Yy]* )
	    echo -e "\nStarting the imaging process ..\n"

	    # umount disk to flash
	    sudo diskutil unmountDisk /dev/disk2

	    # flash it
	    sudo dd bs=1m if=$1 of=/dev/rdisk2

	    # eject the sdcard

	    sudo diskutil eject /dev/disk2

	    echo -e "\nDone! MicroSD imaging complete\n"

	    exit
	    ;;
	[Nn]* )
	    echo -e "\nAbort!\n";
	    exit;;
	* )
	    echo -e "Continue (y/n)? ";;
    esac
done
