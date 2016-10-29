# rpi3-elinux-dev
This project provides a basic Buildroot configuration and scripts to create an Emebdded Linux Image for a Raspberry PI 3 for development and testing with QEMU and board.

## The project still under development!!!

## Setup

Open a terminal in the rpi-elinux directory and follow these steps to build a basic image for the Raspberry PI 3.

First get the buildroot and qemu-rpi-kernel sources, and configure the buildroot environment by typing:

	$ source ./setup-env.sh
	
Now we can build the rpi 3 image by typing:

	$ ./build.sh
