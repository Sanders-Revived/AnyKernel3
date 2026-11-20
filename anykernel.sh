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
supported.versions=
'; } # end properties

# boot shell variables
BLOCK=auto;
IS_SLOT_DEVICE=auto;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# Sanders uses the legacy Android header.  Its DT field is a Qualcomm QCDT
# table, optionally carried by the package as `dt` (or `dt.img`); ak3-core
# copies it to `extra` when repacking the boot image.  If no QCDT file is
# present in the package, installation continues using the existing boot DT
# (or appended DTB in the kernel image).
# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

qcdt="";
for f in "$AKHOME/dt" "$AKHOME/dt.img"; do
  if [ -f "$f" ]; then
    qcdt="$f";
    break;
  fi;
done;

if [ -n "$qcdt" ]; then
  [ "$(od -An -tc -N4 "$qcdt" | tr -d '[:space:]')" = "QCDT" ] || abort "Invalid Sanders QCDT file ($(basename "$qcdt")).";
  ui_print " - Found Sanders QCDT ($(basename "$qcdt"))";
else
  ui_print " - No Sanders QCDT found, continuing without it...";
fi;

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

if [ -n "$qcdt" ] && [ ! -f "$SPLITIMG/extra" ]; then
  cp -f "$qcdt" "$SPLITIMG/extra";
fi;

write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
## end boot install
