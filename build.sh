#!/bin/bash

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
WLANFW_DIR=$UTIL_DIR/wlan-firmware/firmware

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
		echo "Copying overlays and config files to boot partition in sdcard.img..."
		# Store output in a variable to get the loop device index
		LINE=$(sudo kpartx -av $BRIMG_DIR/sdcard.img)
		LOOPDEV="${LINE:8:5}"
		sleep 1
		sudo mount /dev/mapper/${LOOPDEV}p1 /mnt/tmp			
		sleep 1
		sudo cp -R $BRIMG_DIR/rpi-firmware/overlays /mnt/tmp
		sudo cp $WSDTB_DIR/waveshare35a-overlay.dtb /mnt/tmp/overlays/waveshare35a.dtbo
		sudo cp $SCRIPT_DIR/config-35.txt /mnt/tmp/config.txt
		sudo umount /mnt/tmp
		sleep 1
		
		echo "Copying scripts and config files to fs partition in sdcard.img..."
		sudo mount /dev/mapper/${LOOPDEV}p2 /mnt/tmp
		sleep 1
		sudo chmod +x $SCRIPT_DIR/S11fbcp
		sudo cp $FBCP_DIR/build/fbcp /mnt/tmp/usr/bin
		sudo cp $SCRIPT_DIR/S11fbcp /mnt/tmp/etc/init.d
		sudo cp $SCRIPT_DIR/S80hostapd /mnt/tmp/etc/init.d
		sudo cp $SCRIPT_DIR/S80dnsmasq /mnt/tmp/etc/init.d
		sudo cp $SCRIPT_DIR/interfaces-hotspot /mnt/tmp/etc/network/interfaces
		sudo cp $SCRIPT_DIR/hostapd.conf /mnt/tmp/etc/hostapd.conf
		sudo cp $SCRIPT_DIR/dhcpcd.conf /mnt/tmp/etc/dhcpcd.conf
		sudo cp $SCRIPT_DIR/dnsmasq.conf /mnt/tmp/etc/dnsmaq.conf
		sudo cp $WLANFW_DIR/brcm/brcmfmac43430-sdio.bin /mnt/tmp/lib/firmware/brcm
		sudo cp $WLANFW_DIR/brcm/brcmfmac43430-sdio.txt /mnt/tmp/lib/firmware/brcm
		sudo umount /mnt/tmp
		sleep 1
		
		sudo kpartx -d $BRIMG_DIR/sdcard.img
		;;
	flash)
		echo "Formatting $2 to FAT32..."
		(
		echo o # Create a new empty DOS partition table
		echo n # Add a new partition
		echo p # Primary partition
		echo 1 # Partition number
		echo   # First sector (Accept default: 1)
		echo   # Last sector (Accept default: varies)
		echo t # Request to change the partion type
		echo c # Change the partition type to W95 FAT32 (LBA)
		echo w # Write changes
		) | sudo fdisk $2;
		sleep 1
		sudo hdparm -z $2
		
		echo "Flashing sdcard.img to $2..."
		sudo dd if=$BRIMG_DIR/sdcard.img of=$2 bs=1M
		sleep 1
		;;
	*)
		echo "Usage: ./build.sh [OPTION] ..."
		echo ""
		echo "Options:"
		echo "   clean	clean the images built in buildroot"
		echo "   menu		opens the buildroot menuconfig"
		echo "   make	 	builds the rpi3 image with buildroot"
		echo "   fbcp		compiles fbcp source that enables TFT LCD screen in the rpi3"
		echo "   cp2sd	copies configuration files and scripts to the rpi3 image created by buildroot"
		echo "   flash [DEVICE]	formats the sdcard (e.g. /dev/mmcblk0) to FAT32 and flash the rpi3 image to the sdcard"
		;;
esac

