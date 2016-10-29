#!/bin/bash

qemu-system-arm -kernel qemu-rpi-kernel/kernel-qemu-4.4.13-jessie \
-cpu arm1176 \
-m 256 \
-M versatilepb \
-no-reboot \
-serial stdio \
-append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
-redir tcp:2222::22 \
-hda buildroot-$BUILDROOT_VER/output/images/sdcard.img

