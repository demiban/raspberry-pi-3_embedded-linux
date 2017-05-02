#!/bin/bash

IMG_DIR=buildroot/output/images

utils/qemu-system-arm \
-M raspi2 \
-smp 4 \
-kernel $IMG_DIR/zImage \
-sd $IMG_DIR/sdcard.img \
-dtb $IMG_DIR/bcm2710-rpi-3-b.dtb \
-serial stdio

