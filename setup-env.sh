#!/bin/sh


export BUILDROOT_VER=2016.08.1
export QEMU_VER=2.7.0

if [ -d "buildroot-$BUILDROOT_VER" ] 
then
	echo "buildroot-$BUILDROOT_VER: OK."
else
	echo "Downloading Buildroot..."
	wget http://buildroot.net/downloads/buildroot-$BUILDROOT_VER.tar.bz2
	tar xjvf buildroot-$BUILDROOT_VER.tar.bz2
	rm buildroot-$BUILDROOT_VER.tar.bz2
fi


if [ -d "qemu-rpi-kernel" ] 
then
	echo "qemu-rpi-kernel: OK."
else
	echo "Downloading qemu-rpi-kernel..."
	git clone https://github.com/dhruvvyas90/qemu-rpi-kernel.git
fi

if [ -d "qemu-$QEMU_VER" ] 
then	
	echo "qemu-$QEMU_VER: OK."
else
	echo "Downloading qemu-$QEMU_VER..."
	wget http://wiki.qemu-project.org/download/qemu-2.7.0.tar.bz2
	tar xjvf qemu-$QEMU_VER.tar.bz2
	rm qemu-$QEMU_VER.tar.bz2
	
 	echo "Installing qemu dependencies..."
	sudo apt-get install git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev	
fi

if [ -L "qemu-system-arm" ]
then
	echo "qemu-system-arm: OK."
else 
	echo "Building qemu-system-arm..."
	if [ ! -d "qemu-$QEMU_VER/build" ]
	then
		mkdir qemu-$QEMU_VER/build
	fi
	
	cd qemu-$QEMU_VER/build
	../configure --target-list=arm-softmmu --enable-debug
	make -j2

	cd ../..
	ln -s qemu-$QEMU_VER/build/arm-softmmu/qemu-system-arm qemu-system-arm
fi

if [ -L "qemu-system-aarch64" ]
then
	echo "qemu-system-aarch64: OK."
else 
	echo "Building qemu-system-aarch64..."
	if [ ! -d "qemu-$QEMU_VER/build" ]
	then
		mkdir qemu-$QEMU_VER/build
	fi
	
	cd qemu-$QEMU_VER/build
	../configure --target-list=aarch64-softmmu --enable-debug
	make -j2

	cd ../..
	ln -s qemu-$QEMU_VER/build/aarch64-softmmu/qemu-system-aarch64 qemu-system-aarch64
fi

echo "Configuring buildroot for Raspberry PI 3 image..."

cd buildroot-$BUILDROOT_VER
cp ../config/rpi3_config .config

cd ..

echo "Done!"
