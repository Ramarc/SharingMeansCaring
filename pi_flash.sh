#!/bin/bash

# this script flashes microSD from linux with a specified image
# file. It has been tested with Unbuntu 16.04

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

usage: sudo ./pi_flash.sh PATH/TO/IMG_FILE

The latest image can be downloaded from
https://www.raspberrypi.org/downloads/raspbian/

EOF
    exit
fi

if [ ! "$1" ]; then
    cat <<EOF
ERROR: image file not specified .. Abort!

usage: sudo ./pi_flash.sh PATH/TO/IMG_FILE

EOF
    exit
fi

if [ ! -f $1 ]; then
    cat <<EOF
ERROR: image file $1 not found .. Abort!

EOF
    exit
else
    echo -e "PASS: Image File is $1"
fi

if [ ! -f /bin/dd ]; then
    echo -e "ERROR: utility /bin/dd not found .. Abort!"
    exit
else
    echo -e "PASS: Found utility /bin/dd"
    IMAGER='/bin/dd'
fi

if [ ! -f /usr/bin/dcfldd ]; then
    echo -e "ERROR: utility /usr/bin/dcfldd not found .. Abort!"
    exit
else
    echo -e "PASS: Found utility /usr/bin/dcfldd"
    IMAGER='/usr/bin/dcfldd'
fi

if [ ! $IMAGER ]; then
    echo -e "ERROR: no imager found .. Abort!"
    exit
fi

if [ ! -f /sbin/parted ]; then
    echo -e "ERROR: utility /sbin/parted not found .. Abort!"
    exit
else
    echo -e "PASS: Found utility /sbin/parted"
fi

if [ ! -f /sbin/e2fsck ]; then
    echo -e "ERROR: utility /sbin/e2fsck not found .. Abort!"
    exit
else
    echo -e "PASS: Found utility /sbin/e2fsck"
fi

PARTITION=$(df -k | grep /dev/sdb1 | sed -r 's/\ +/\ /g' | cut -d " " -f1 )
ID=$(df -k | grep /dev/sdb1 | sed -r 's/\ +/\ /g' | cut -d " " -f6 )

if [ ! "$PARTITION" ] ; then
    echo -e "ERROR: It doesn't appear the MicroSD is mounted .. Abort!"
    exit
else
    echo -e "PASS: MicroSD found at $PARTITION ($ID)"
fi

PARTBLOCK=${PARTITION: :-1}
PARTBIG=$PARTBLOCK

# this identifies the partition to be extended for disk
PARTBIG+="2"

echo -e "PASS: Partition Block identified as $PARTBLOCK\n"

echo -e "Unmounting $PARTITION\n"

/bin/umount $PARTITION

if [ "$PARTBIG" ] ; then
    /bin/umount $PARTBIG
fi

TESTPAR=$(df -k | grep /dev/sdb | sed -r 's/\ +/\ /g' | cut -d " " -f1 )

if [ ! "$TESTPAR" ] ; then
    echo -e "PASS: $PARTITION successfully unmounted\n"
else
    echo -e "ERROR: There are still partitions ($TESTPAR) .. Abort!\n"
    exit
fi

while true; do
    cat <<EOF
This script assumes the microSD card is mounted to /dev/sdb

If this is the correct mount point, select Y to continue. Otherwise,
select N and update the script below to the appropriate mount point.

EOF

    read -p "Continue (y/n)? " yn
    case $yn in
	[Yy]* )
	    echo "\nStarting the imaging process ..\n";
	    echo "\n$IMAGER bs=1M if=$1 of=${PARTITION: :-1}\n";

	    $IMAGER bs=1M if=$1 of=${PARTITION: :-1}

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
