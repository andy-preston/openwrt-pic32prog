Overview
========

An OpenWRT package to cross-compile pic32prog.

Currently, the master branch only works with the "bitbang" adaptor.
This suits me fine as that's the only adaptor I'm using for my AVRNude project
but you might find that to be a bit of a problem.

* https://github.com/sergev/pic32prog
* https://openwrt.org/
* https://hackaday.io/project/163934-avrnude

Building
========

This is my build script, your milage WILL vary

    rm -rf openwrt-sdk-18.06.1-brcm63xx-smp_gcc-7.3.0_musl.Linux-x86_64/
    tar xvf ../openwrt/openwrt-sdk-18.06.1-brcm63xx-smp_gcc-7.3.0_musl.Linux-x86_64.tar.xz
    cd openwrt-sdk-18.06.1-brcm63xx-smp_gcc-7.3.0_musl.Linux-x86_64/
    cd package
    git clone git@gitlab.com:edgeeffect/openwrt-pic32prog.git pic32prog
    cd pic32prog
    git checkout libhidapi
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

makefile.patch - target.patch (only on master Branch)
-----------------------------------------------------

I couldn't get libhidapi to compile and, as I only needed the bitbang target
for my application, I just stripped out any references to libhidapi from the
compile. (Life is too short for GNU Autotools)

This can be fixed when I try a local build in Ubuntu by installing pkg-config.
I'm not sure if this will work when I try in the OpenWRT SDK... time will tell.

serial.patch
------------

Improved serial IO handling "stolen" from avrdude

serial2.patch
-------------

I assume, when building on desktop Linux, that `#include <sys/time.h>` is
included by default or something. When cross-compiling I got loads of errors
regarding the size of the `timeval` struct that went away when I included
this header.

hidapi-include.patch hidapi-makefile.patch (not on master branch yet)
---------------------------------------------------------------------

Instead of using a local `libhidapi-libusb` included as a git submodule,
use the OpenWRT library package `hidapi`.
