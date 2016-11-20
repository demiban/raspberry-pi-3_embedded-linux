#!/bin/sh

# Diirectories 
TOP_DIR=$PWD
BR_DIR=$TOP_DIR/buildroot
BRIMG_DIR=$BR_DIR/output/images
BRHOST_DIR=$BR_DIR/output/host
BRBUILD_DIR=$BR_DIR/output/build
BRSYSROOT_DIR=$BRHOST_DIR/usr/arm-rpi3-linux-uclibcgnueabihf/sysroot
UTIL_DIR=$TOP_DIR/utils
SCRIPT_DIR=$UTIL_DIR/scripts
FBCP_DIR=$UTIL_DIR/rpi-fbcp
WSDTB_DIR=$UTIL_DIR/waveshare-dtoverlays

# Variables
CROSS_PREFIX=arm-rpi3-linux-uclibcgnueabihf

case $1 in
	clean)
		cd $BR_DIR
		make clean
		cd ..
		;;
	menu)
		cd $BR_DIR
		make menuconfig
		cd ..
		;;
	make)
		echo "Starting to build rpi image..."
		cd $BR_DIR
		make ARCH=arm -j4 > build.log
		cd ..
		;;
	flash)
		echo "Flashing sdcard.img to $2..."
		sudo dd if=$BRIMG_DIR/sdcard.img of=$2 bs=1M
		;;
	fbcp)
		echo "Compiling fbcp binary..."
		cd $FBCP_DIR
		
		cp $SCRIPT_DIR/CMakeLists.txt $FBCP_DIR/CMakeLists.txt
		ln -s $BR_DR/output/build/host-rpi-firmware*/opt opt 

		mkdir build
		cd build
		export PATH=$BRHOST_DIR:$BRHOST_DIR/usr/bin:$BRSYSROOT_DIR:$PATH		
		cmake -DCMAKE_TOOLCHAIN_FILE=$BRHOST_DIR/usr/share/buildroot/toolchainfile.cmake ..
		make
		$CROSS_PREFIX-strip -s fbcp
		cd $TOP_DIR
		;;
	cp2sd)
		echo "Copying additionals files to sdcard.img boot partition..."
		sudo kpartx -av $BRIMG_DIR/sdcard.img
		sleep 1
		sudo mount /dev/mapper/loop0p1 /mnt/tmp			
		sleep 1
		sudo cp -R $BRIMG_DIR/rpi-firmware/overlays /mnt/tmp
		sudo cp $WSDTB_DIR/waveshare35a-overlay.dtb /mnt/tmp/overlays/waveshare35a.dtbo
		sudo cp $SCRIPT_DIR/config-35.txt /mnt/tmp/config.txt
		sudo umount /mnt/tmp
		sleep 1
		
		echo "Copying additionals files to sdcard.img fs partition..."
		sudo mount /dev/mapper/loop0p2 /mnt/tmp
		sleep 1
		sudo chmod +x $SCRIPT_DIR/S11fbcp
		sudo cp $FBCP_DIR/build/fbcp /mnt/tmp/usr/bin
		sudo cp $SCRIPT_DIR/S11fbcp /mnt/tmp/etc/init.d
		sudo umount /mnt/tmp
		sleep 1
		
		sudo kpartx -d $BRIMG_DIR/sdcard.img
		;;
	*)
		echo "Usage: ./build.sh [OPTION] [SD DEVICE]"
		echo ""
		echo "Options:"
		echo "   clean		clean the images built in buildroot"
		echo "   menu			opens the buildroot menuconfig"
		echo "   make	 		starts building the rpi3 images in buildroot"
		echo "   flash [sd-device]	starts copying the sdcard.img from buildroot to the sd-device (e.g. /dev/mmcblk0)"
		echo "   fbcp			compiles fbcp source to be able to use TFT LCD screen in the rpi3"
		echo "   cp2sd [sd-boot-partition] [sd-fs-partition]	copies additoinal files needed in the rpi-sdcard image (e.g. /media/user/sd-boot-parttion-id)"
		;;
esac

cd ..

