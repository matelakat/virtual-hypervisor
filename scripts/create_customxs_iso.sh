#!/bin/bash

# Useful: 
# http://blogs.citrix.com/2010/10/18/how-to-install-citrix-xenserver-from-a-usb-key-usb-built-from-windows-os/
# http://scnr.net/blog/index.php/archives/177
# http://www.ithastobecool.com/tag/xenclient/
# http://forums.citrix.com/message.jspa?messageID=1479624
# http://blogs.citrix.com/2012/07/13/xs-unattended-install/

set -eux

[ -e hypervisor.iso ]

# extract iso
rm -rf xstgt && mkdir -p xstgt && 7z x hypervisor.iso -oxstgt

# Initrd re-generation
rm -rf ./initrd && mkdir ./initrd

# extract initrd
cd ./initrd

(
cat << FAKEROOT
zcat ../xstgt/install.img | cpio -idum

# Do the remastering
cp ../data/answers.txt ./
cp ../data/postinst.sh ./
cp ../data/firstboot.sh ./

# Re-pack initrd
find . -print | cpio -o -H newc | xz --format=lzma | dd of=../xstgt/install.img

FAKEROOT
) | fakeroot bash

cd ..

rm -rf ./initrd

# bash --rcfile /dev/null -i
cp ./data/isolinux.cfg ./xstgt/boot/isolinux/isolinux.cfg

echo '/boot 1000' > sortlist
mkisofs -joliet -joliet-long -r -b boot/isolinux/isolinux.bin \
-c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
-boot-info-table -sort sortlist -V "My Custom XenServer ISO" -o customxs.iso ./xstgt/

rm -rf ./xstgt

