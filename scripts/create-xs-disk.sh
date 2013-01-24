#!/bin/bash

# Useful: 
# http://blogs.citrix.com/2010/10/18/how-to-install-citrix-xenserver-from-a-usb-key-usb-built-from-windows-os/
# http://scnr.net/blog/index.php/archives/177
# http://www.ithastobecool.com/tag/xenclient/
# http://forums.citrix.com/message.jspa?messageID=1479624

set -eux

dd if=/dev/zero of=xsdrive.raw bs=1048576 count=1024

sudo kpartx -av xsdrive.raw

sudo dd if=/usr/lib/syslinux/mbr.bin of=/dev/loop0
# USE sudo losetup -a to get the correct loopback device number!

echo ",,6,*" | sudo sfdisk /dev/loop0 -u M -D

sudo kpartx -d xsdrive.raw
sleep 1
sudo kpartx -av xsdrive.raw
sleep 1

# Make filesystem
sudo mkfs.vfat /dev/mapper/loop0p1

sudo syslinux /dev/mapper/loop0p1

sudo mkdir -p /tmp/xsbp && sudo mount -o loop hypervisor.iso /tmp/xsbp

sudo mkdir -p /tmp/xstgt && sudo mount -t vfat /dev/mapper/loop0p1 /tmp/xstgt

sudo cp -a /tmp/xsbp/* /tmp/xstgt/

#sudo cp /tmp/xstgt/boot/isolinux/* /tmp/xstgt/

#sudo mv /tmp/xstgt/{iso,sys}linux.cfg
#sudo mv /tmp/xstgt/{iso,sys}linux.bin
#sudo cp /usr/lib/syslinux/mboot.c32 /tmp/xstgt/


# Initrd re-generation
rm -rf ./initrd && mkdir ./initrd
cd ./initrd
zcat /tmp/xstgt/install.img | sudo cpio -ivdum
#bash --rcfile /dev/null -i
(
cat << EOF
<?xml version="1.0"?>
<installation srtype="ext">
<primary-disk>sda</primary-disk>
<keymap>us</keymap>
<root-password>somepass</root-password>
<source type="local"></source>
<admin-interface name="eth0" proto="dhcp" />
<timezone>America/Los_Angeles</timezone>
</installation>
EOF
) | sudo dd of=answers.txt

sudo find . -print | sudo cpio -o -H newc | xz --format=lzma | sudo dd of=/tmp/xstgt/install.img
cd ..

# bash --rcfile /dev/null -i
sudo cp syslinux.cfg /tmp/xstgt/boot/isolinux/isolinux.cfg

sudo umount /tmp/xsbp

echo '/boot 1000' > /tmp/sortlist
sudo mkisofs -joliet -joliet-long -r -b boot/isolinux/isolinux.bin \
-c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
-boot-info-table -sort /tmp/sortlist -V "My Custom XenServer ISO" -o customxs.iso /tmp/xstgt/

sudo umount /tmp/xstgt

sudo kpartx -d xsdrive.raw

# Convert and attach the raw image to the machine
vboxmanage storagectl STUFF --name "IDECONTROLLER" --remove || true
#vboxmanage closemedium disk xsdrive.vdi --delete

#vboxmanage convertfromraw xsdrive.raw xsdrive.vdi --format VDI

vboxmanage storagectl STUFF --name "IDECONTROLLER" --add ide
vboxmanage storageattach "STUFF" --storagectl IDECONTROLLER --type dvddrive --medium "`pwd`/customxs.iso" --port 0 --device 0
