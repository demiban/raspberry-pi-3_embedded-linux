#!/bin/sh


export BUILDROOT_VER=2016.08.1

if [ -d "buildroot-$BUILDROOT_VER" ] 
then
	echo "Directory buildroot-$BUILDROOT_VER exists."
else
	echo "Downloading Buildroot..."
	wget http://buildroot.net/downloads/buildroot-$BUILDROOT_VER.tar.bz2
	tar xjvf buildroot-$BUILDROOT_VER.tar.bz2
	rm buildroot-$BUILDROOT_VER.tar.bz2
fi


if [ -d "qemu-rpi-kernel" ] 
then
	echo "Directory qemu-rpi-kernel exists."
else
	echo "Downloading qemu-rpi-kernel..."
	git clone https://github.com/dhruvvyas90/qemu-rpi-kernel.git
fi

echo "Configuring buildroot for Raspberry PI 3 image..."

cd buildroot-$BUILDROOT_VER
cp ../config/rpi3_config .config

cd ..

echo "Done!"
