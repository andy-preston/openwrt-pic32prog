Overview
========

An OpenWRT package to cross-compile pic32prog.

* https://github.com/sergev/pic32prog
* https://openwrt.org/
* https://github.com/andy-preston/avrnude

This is only being tested against the bitbang adaptor... as that's the only
adaptor that I use. If you want to use it with another adaptor, I'm afraid
you're on your own.

Building
========

This is my build script, your milage WILL vary

    rm -rf openwrt-sdk-18.06.1-brcm63xx-smp_gcc-7.3.0_musl.Linux-x86_64/
    tar xvf ../openwrt/openwrt-sdk-18.06.1-brcm63xx-smp_gcc-7.3.0_musl.Linux-x86_64.tar.xz
    cd openwrt-sdk-18.06.1-brcm63xx-smp_gcc-7.3.0_musl.Linux-x86_64/
    cd package
    git clone git@gitlab.com:edgeeffect/openwrt-pic32prog.git pic32prog
    cd pic32prog
    # git checkout libhidapi
    cd ../..
    make menuconfig
    # Deselect "Select all target specific packages by default"
    # Deselect "Select all kernel module packages by default"
    # Deselect "Select all userspace packages by default"
    # Select "pic32prog" under "Utilities"
    export LANG=C
    scripts/feeds update -a
    scripts/feeds install libusb
    scripts/feeds install libudev-fbsd
    scripts/feeds install libc
    scripts/feeds install libusb-1.0
    scripts/feeds install librt
    scripts/feeds install hidapi
    make package/pic32prog/compile -j1 V=s
    file staging_dir/target-mips_mips32_musl/root-brcm63xx/usr/bin/pic32prog

Patches
=======

serial-handling.patch
---------------------

I had a problem that during the initialisation of the bitbang adaptor,
pic32prog sends the '?' command to the adaptor and expects the string
"ascii ICSP v1E" or "ascii ICSP v1C" to be returned and I was just getting the
first character back.

I patched serial.c by "stealing" the serial read function from *avrdude*.

*avrdude* had a loop around it's serial read code that repeatedly re-read the
source until the required string-length was added to the buffer.

serial-headers.patch
--------------------

I assume, when building on desktop Linux, that `#include <sys/time.h>` is
included by default or something. When cross-compiling I got loads of errors
regarding the size of the `timeval` struct that went away when I included
this header.

hidapi-include.patch hidapi-makefile.patch
------------------------------------------

Instead of using a local `libhidapi-libusb` included as a git submodule,
use the OpenWRT library package `hidapi`.

