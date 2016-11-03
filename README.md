# rpi3-elinux-dev
This project provides Buildroot configuration and scripts to create a custom Embedded Linux Image for a Raspberry PI 3.

## The project still under development!!!

## Setup

Open a terminal in the rpi-elinux directory and follow these steps to build a basic image for the Raspberry PI 3.

First get the buildroot and qemu-rpi-kernel sources, and configure the buildroot environment by typing:

	$ source ./setup-env.sh
	
Now we can build the rpi 3 image by typing:

	$ ./build.sh
