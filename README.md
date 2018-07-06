# raspberry-pi-3_embedded-linux
This project provides Buildroot configuration and scripts to generate a custom Embedded Linux Image for a Raspberry PI 3.

Open a terminal in the raspberry-pi-3_embedded-linux directory and follow these steps to build a basic image for the Raspberry PI 3.

# Description

# Getting Started

## Setup

1. Change the following scripts to executables:
	
	$ chmod +x setup-env.sh build.sh run-emu.sh

2. Get all the sources needed to build the image and configure buildroot by typing:

	$ ./setup-env.sh
	
## Build

1. Now we can build the rpi 3 image by typing:

	$ ./build.sh make
	
If any error occurred on the build, open the build.log in the buildroot directory.

2. Build the fbcp binary to enable the /dev/fb1 to display the content in the LCD screen:

	"$ build.sh fbcp"

3. Copy the fbcp and additionals files to the sdcard.img created by buildroot to enable the 3.5" SPI LCD screen.
	
	$ ./build.sh cp2sd
	
4. Insert the sdcard and flash the rpi3 image:

	$ ./build.sh flash /dev/mmcblk0
	
The flash command will format the sdcard to FAT32 before flashing,
so you don't have to manually format the sdcard.
Important: Do not use /dev/mmcblk0p1, it won't work.

## Run

1. Now you can insert the sdcard in the raspberry pi 3 with the 3.5 LCD screen and power it up.

The following message should appear:

	"Welcome to Embedded linux on Raspberry Pi 3!"
	
2. Login to the raspberry:

	$ rpi login: root
	$ password: rpi3

## References

1. Wifi firmware fix:
	http://lists.busybox.net/pipermail/buildroot/2016-April/159688.html
	
2. TFT screen and fbcp setup:
	https://github.com/recalbox/recalbox-os/wiki/TFT-Screen-SPI-Bus-%28EN%29
	
3. Connect to a wifi network:
	http://linuxcommando.blogspot.com/2013/10/how-to-connect-to-wpawpa2-wifi-network.html
	
	http://recalbox-wiki-rtfd.readthedocs.io/en/4.0/EN/Utility---Use-of-fbcp-for-small-TFT-screen-(EN)/
	
	https://delog.wordpress.com/2014/10/10/wireless-on-raspberry-pi-with-buildroot/

4. Hotspot:

	https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd/

	https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=141807
	
