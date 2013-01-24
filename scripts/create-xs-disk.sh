#!/bin/bash

# Useful: 
# http://blogs.citrix.com/2010/10/18/how-to-install-citrix-xenserver-from-a-usb-key-usb-built-from-windows-os/
# http://scnr.net/blog/index.php/archives/177
# http://www.ithastobecool.com/tag/xenclient/
# http://forums.citrix.com/message.jspa?messageID=1479624

set -eux

# extract iso
rm -rf xstgt && mkdir -p xstgt && 7z x hypervisor.iso -oxstgt

# Initrd re-generation
sudo rm -rf ./initrd && mkdir ./initrd

# extract initrd
cd ./initrd
zcat ../xstgt/install.img | sudo cpio -ivdum

# Do the remastering
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

# Re-pack initrd
sudo find . -print | sudo cpio -o -H newc | xz --format=lzma | sudo dd of=../xstgt/install.img
cd ..

# bash --rcfile /dev/null -i
sudo cp syslinux.cfg ./xstgt/boot/isolinux/isolinux.cfg

echo '/boot 1000' > sortlist
sudo mkisofs -joliet -joliet-long -r -b boot/isolinux/isolinux.bin \
-c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
-boot-info-table -sort sortlist -V "My Custom XenServer ISO" -o customxs.iso ./xstgt/

# Convert and attach the raw image to the machine
vboxmanage storagectl STUFF --name "IDECONTROLLER" --remove || true
#vboxmanage closemedium disk xsdrive.vdi --delete

#vboxmanage convertfromraw xsdrive.raw xsdrive.vdi --format VDI

vboxmanage storagectl STUFF --name "IDECONTROLLER" --add ide
vboxmanage storageattach "STUFF" --storagectl IDECONTROLLER --type dvddrive --medium "`pwd`/customxs.iso" --port 0 --device 0
