#!/bin/sh

cd buildroot

case $1 in
	clean)
		make clean
		;;
	menu)
		make menuconfig
		;;
	make)
		echo "Starting to build rpi image..."
		make > build.log
		;;
	*) 
		make menuconfig

		echo "Starting to build rpi image..."
		make > build.log
		;;
esac

cd ..

