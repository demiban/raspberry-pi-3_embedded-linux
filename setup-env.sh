#!/bin/sh

# This scripts downloads and compiles the required tools to setup the
# development environment for embedded linix with Raspberry pi 3

export BUILDROOT_VER=2016.08.1

if hash git 2>/dev/null; then
	echo "git: OK."
else
	sudo apt install git
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


if [ -d "qemu-rpi-kernel" ] 
then
	echo "qemu-rpi-kernel: OK."
else
	echo "Downloading qemu-rpi-kernel..."
	git clone https://github.com/dhruvvyas90/qemu-rpi-kernel.git
fi

if [ -d "qemu" ] 
then	
	echo "qemu: OK."
else
	echo "Downloading qemu..."
	git clone https://github.com/qemu/qemu.git
	
 	echo "Installing qemu dependencies..."
	sudo apt-get install git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev	
fi

if [ -L "qemu-system-arm" ]
then
	echo "qemu-system-arm: OK."
else 
	echo "Building qemu-system-arm..."
	if [ ! -d "qemu/build" ]
	then
		mkdir qemu/build
	fi
	
	cd qemu/build
	../configure --target-list=arm-softmmu --enable-debug
	make -j2

	cd ../..
	ln -s qemu/build/arm-softmmu/qemu-system-arm qemu-system-arm
fi

if [ -L "qemu-system-aarch64" ]
then
	echo "qemu-system-aarch64: OK."
else 
	echo "Building qemu-system-aarch64..."
	if [ ! -d "qemu/build" ]
	then
		mkdir qemu/build
	fi
	
	cd qemu/build
	../configure --target-list=aarch64-softmmu --enable-debug
	make -j2

	cd ../..
	ln -s qemu/build/aarch64-softmmu/qemu-system-aarch64 qemu-system-aarch64
fi

echo "Configuring buildroot for Raspberry PI 3 image..."

cd buildroot
cp ../config/rpi3_config .config

cd ..

echo "Done!"
