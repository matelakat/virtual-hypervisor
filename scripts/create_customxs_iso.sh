#!/bin/bash

# Useful: 
# http://blogs.citrix.com/2010/10/18/how-to-install-citrix-xenserver-from-a-usb-key-usb-built-from-windows-os/
# http://scnr.net/blog/index.php/archives/177
# http://www.ithastobecool.com/tag/xenclient/
# http://forums.citrix.com/message.jspa?messageID=1479624
# http://blogs.citrix.com/2012/07/13/xs-unattended-install/

set -eu

[ -e hypervisor.iso ]

TOP_DIR=$(cd $(dirname "$0") && cd .. && pwd)
ISOROOT=`mktemp -d`

# extract iso
7z x "hypervisor.iso" "-o${ISOROOT}"


INITRDROOT=`mktemp -d`

cat << FAKEROOT | fakeroot bash
cd "$INITRDROOT"
zcat "$ISOROOT/install.img" | cpio -idum

# Do the remastering
cp "$TOP_DIR/data/answerfile.xml" ./
cp "$TOP_DIR/data/postinst.sh" ./
cp "$TOP_DIR/data/firstboot.sh" ./

# Re-pack initrd
find . -print | cpio -o -H newc | xz --format=lzma | dd of="${ISOROOT}/install.img"
FAKEROOT

rm -rf "$INITRDROOT"

cp "$TOP_DIR/data/isolinux.cfg" "${ISOROOT}/boot/isolinux/isolinux.cfg"

echo '/boot 1000' > sortlist
mkisofs -joliet -joliet-long -r -b boot/isolinux/isolinux.bin \
-c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
-boot-info-table -sort sortlist -V "My Custom XenServer ISO" -o customxs.iso "$ISOROOT"

rm -rf "$ISOROOT"
