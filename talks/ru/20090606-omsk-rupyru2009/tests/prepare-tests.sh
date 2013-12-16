#!/bin/sh

for arch in arm-ip-linux-gnueabi mipsel-ip-linux-gnu; do
    rm -rf $arch || :
    mkdir -p $arch
    make clean
    make CROSS_PREFIX=$arch-
    cp -a c python ruby runtests.sh snapmem.sh $arch
    make clean
done
