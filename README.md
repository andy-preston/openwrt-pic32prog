Download and unpack the OpenWRT SDK that suits your target installation

In the SDK's package directory clone my repository

    cd package
    git clone git@gitlab.com:edgeeffect/openwrt-pic32prog.git
    mv openwrt-pic32prog pic32prog
    cd ..
    make menuconfig

Deselect/exclude the following options:

* Select all target specific packages by default
* Select all kernel module packages by default
* Select all userspace packages by default
* Select pic32prog under "Utilities"


    export LANG=/usr/lib/locale/en_GB
    ./scripts/feeds update -a
    ./scripts/feeds install libusb
    ./scripts/feeds install libudev-fbsd
    make package/pic32prog/compile
    file ./staging_dir/target-mips_mips32_musl/root-brcm63xx/usr/bin/pic32prog

