#!/bin/bash

IMG_DIR=buildroot/output/images

utils/qemu-system-aarch64 -M raspi2 \
-cpu cortex-a7 \
-smp 4 \
-m 1024 \
-kernel $IMG_DIR/zImage \
-dtb $IMG_DIR/bcm2710-rpi-3-b.dtb \
-sd $IMG_DIR/sdcard.img \
-serial stdio

