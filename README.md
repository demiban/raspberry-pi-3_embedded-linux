# rpi3-elinux-dev
This project provides Buildroot configuration and scripts to create a custom Embedded Linux Image for a Raspberry PI 3 with a LCD screen.

Open a terminal in the rpi-elinux directory and follow these steps to build a basic image for the Raspberry PI 3.

## Setup

1. Change the following scripts to executables:
	
	"$ chmod +x setup-env.sh build.sh run-emu.sh"

2. Get all the sources needed to build the image and configure the buildroot environment by typing:

	"$ ./setup-env.sh"
	
3. Insert the sdcard to the computer and format it to fat32 using gparted or disk.
	
## Build

1. Now we can build the rpi 3 image by typing:

	"$ ./build.sh make"
	
If any error occurred on the build, open the build.log in the buildroot directory.

2. Build the fbcp binary to enable the /dev/fb1 to display the content in the LCD screen:

	"$ build.sh fbcp"

3. Copy the fbcp and additionals files to the sdcard.img created by buildroot to enable the 3.5" SPI LCD screen.
	
	"$ ./build.sh cp2sd"
	
4. Burn the sdcard.img to the sdcard device:

	"$ ./build.sh flash /dev/mmcblk0"
	
Important: Do not use /dev/mmcblk0p1, it won't work.

## Run

1. Now you can insert the sdcard in the raspberry pi 3 with the 3.5 LCD screen and power it up.

The following message should appear:

	"Welcome to Emebdded linux on Raspberry Pi 3!"
	
2. Login to the raspberry:

	"rpi login: root"
	"password: rpi3"
	
