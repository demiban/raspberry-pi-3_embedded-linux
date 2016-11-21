#!/bin/sh

# This scripts downloads and compiles the required tools to setup the
# development environment for embedded linix with Raspberry pi 3

export BUILDROOT_VER=2016.08.1

if hash git 2>/dev/null; then
	echo "git: OK."
else
	sudo apt install git
fi

if hash kpartx 2>/dev/null; then
	echo "kpartx: OK."
else
	sudo apt install kpartx
fi
 
if [ -d "buildroot" ] 
then
	echo "buildroot: OK."
else
	echo "Downloading Buildroot..."
	wget http://buildroot.net/downloads/buildroot-$BUILDROOT_VER.tar.bz2
	tar xjvf buildroot-$BUILDROOT_VER.tar.bz2
	mv buildroot-$BUILDROOT_VER buildroot
	rm buildroot-$BUILDROOT_VER.tar.bz2
	sudo apt install libncurses5-dev
fi

if [ -d "utils/waveshare-dtoverlays" ] 
then
	echo "waveshare-dtoverlays: OK."
else
	echo "Downloading waveshare-dtoverlays..."
	cd utils
	git clone https://github.com/swkim01/waveshare-dtoverlays.git
	cd ..
fi

if [ -d "utils/qemu" ] 
then	
	echo "qemu: OK."
else
	echo "Downloading qemu..."
	cd utils
	git clone https://github.com/qemu/qemu.git
	cd ..
 	echo "Installing qemu dependencies..."
	sudo apt-get install libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev	
fi

if [ -L "utils/qemu-system-arm" ]
then
	echo "qemu-system-arm: OK."
else 
	echo "Building qemu-system-arm..."
	if [ ! -d "utils/qemu/build" ]
	then
		mkdir utils/qemu/build
	fi
	
	cd utils/qemu/build
	../configure --target-list=arm-softmmu --enable-debug
	make -j2

	cd ../..
	ln -s qemu/build/arm-softmmu/qemu-system-arm qemu-system-arm
	cd ..
fi

if [ -L "utils/qemu-system-aarch64" ]
then
	echo "qemu-system-aarch64: OK."
else 
	echo "Building qemu-system-aarch64..."
	if [ ! -d "utils/qemu/build" ]
	then
		mkdir utils/qemu/build
	fi
	
	cd utils/qemu/build
	../configure --target-list=aarch64-softmmu --enable-debug
	make -j2

	cd ../..
	ln -s qemu/build/aarch64-softmmu/qemu-system-aarch64 qemu-system-aarch64
	cd ..
fi

if [ -d "utils/rpi-fbcp" ] 
then	
	echo "rpi-fbcp: OK."
else
	echo "Downloading rpi-fbcp..."
	cd utils
	git clone https://github.com/ian57/rpi-fbcp.git
	cd ..
fi

echo "Configuring buildroot for Raspberry PI 3 image..."

cp config/rpi3_config buildroot/.config

echo "Done!"
