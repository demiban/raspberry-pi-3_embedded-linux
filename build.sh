#!/bin/sh

cd buildroot-$BUILDROOT_VER

echo 
make menuconfig

echo "Starting build, this may take a while..."
make > build.log

cd ..
