### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Aurora-Kernel
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=sanders
'; } # end properties

# boot shell variables
BLOCK=auto;
IS_SLOT_DEVICE=auto;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# Sanders uses the legacy Android header.  Its DT field is a Qualcomm QCDT
# table, carried by the package as `dt`; ak3-core copies it to `extra` when
# repacking the boot image.  The build script generates this file from the
# four Sanders DTBs and preserves the stock board-ID mapping.
# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

[ -f dt ] || abort "Sanders QCDT file (dt) is missing from this package.";
[ "$(od -An -tc -N4 dt | tr -d '[:space:]')" = "QCDT" ] || abort "Invalid Sanders QCDT file.";

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
## end boot install
