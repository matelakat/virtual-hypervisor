#!/bin/bash

# Useful: http://blogs.citrix.com/2010/10/18/how-to-install-citrix-xenserver-from-a-usb-key-usb-built-from-windows-os/

set -eux

dd if=/dev/zero of=xsdrive.raw bs=1048576 count=1024

sudo kpartx -av xsdrive.raw

sudo dd if=/usr/lib/syslinux/mbr.bin of=/dev/loop0
# USE sudo losetup -a to get the correct loopback device number!

echo ",,6,*" | sudo sfdisk /dev/loop0 -u M -D

sudo kpartx -d xsdrive.raw
sudo kpartx -av xsdrive.raw

# Make filesystem
sudo mkfs.vfat /dev/mapper/loop0p1

sudo syslinux /dev/mapper/loop0p1

sudo mkdir -p /tmp/xsbp && sudo mount -o loop hypervisor.iso /tmp/xsbp

sudo mkdir -p /tmp/xstgt && sudo mount -t vfat /dev/mapper/loop0p1 /tmp/xstgt

sudo cp -a /tmp/xsbp/* /tmp/xstgt/

sudo cp /tmp/xstgt/boot/isolinux/* /tmp/xstgt/

sudo mv /tmp/xstgt/{iso,sys}linux.cfg
sudo mv /tmp/xstgt/{iso,sys}linux.bin
sudo cp /usr/lib/syslinux/mboot.c32 /tmp/xstgt/

sudo umount /tmp/xsbp
sudo umount /tmp/xstgt

sudo kpartx -d xsdrive.raw

# Convert and attach the raw image to the machine
vboxmanage storagectl STUFF --name "IDECONTROLLER" --remove || true
vboxmanage closemedium disk xsdrive.vdi --delete

vboxmanage convertfromraw xsdrive.raw xsdrive.vdi --format VDI

vboxmanage storagectl STUFF --name "IDECONTROLLER" --add ide
vboxmanage storageattach "STUFF" --storagectl IDECONTROLLER --type hdd --medium "`pwd`/xsdrive.vdi" --port 0 --device 0
