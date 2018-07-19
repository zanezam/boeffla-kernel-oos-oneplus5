# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=###kernelname###
do.devicecheck=1
do.modules=1
do.system=1
do.cleanup=1
do.cleanuponabort=0
device.name1=dumpling
device.name2=OnePlus5T
device.name3=oneplus5T
device.name4=OnePlus 5T
device.name5=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chmod -R 755 $ramdisk/sbin;
chown -R root:root $ramdisk/*;


## AnyKernel install
dump_boot;

# begin ramdisk changes

# AnyKernel permissions
chmod 775 $ramdisk/sbin
chmod 755 $ramdisk/sbin/bb
chmod 755 $ramdisk/sbin/e2fsck

chmod 775 $ramdisk/res
chmod -R 755 $ramdisk/res/bc
chmod -R 755 $ramdisk/res/misc

# ramdisk changes
rm $ramdisk/sbin/busybox

# end ramdisk changes

write_boot;

## end install

