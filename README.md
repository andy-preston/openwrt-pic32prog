Overview
========

An OpenWRT package to cross-compile pic32prog.

* https://github.com/sergev/pic32prog
* https://openwrt.org/
* https://hackaday.io/project/163934-avrnude

Building
========

Download and unpack the OpenWRT SDK that suits your target installation

In the SDK's package directory clone my repository

    cd package
    git clone git@gitlab.com:edgeeffect/openwrt-pic32prog.git pic32prog
    cd ..
    make menuconfig

Deselect/exclude the following options:

* Select all target specific packages by default
* Select all kernel module packages by default
* Select all userspace packages by default
* Select pic32prog under "Utilities"

Now let's build:

    export LANG=C
    scripts/feeds update -a
    scripts/feeds install libudev-fbsd
    scripts/feeds install libc
    scripts/feeds install libusb-1.0
    scripts/feeds install librt
    scripts/feeds install hidapi
    make package/pic32prog/compile
    file staging_dir/target-mips_mips32_musl/root-brcm63xx/usr/bin/pic32prog

Patches
=======

serial.patch
------------

I assume, when building on desktop Linux, that `#include <sys/time.h>` is
included by default or something. When cross-compiling I got loads of errors
regarding the size of the `timeval` struct that went away when I included
this header.
