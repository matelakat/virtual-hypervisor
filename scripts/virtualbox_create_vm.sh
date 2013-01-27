#!/bin/bash
set -eux

vboxmanage createvm --name "STUFF" --register --basefolder "`pwd`/STUFF"
vboxmanage createhd --filename "`pwd`/stuff.vdi" --size=20000

vboxmanage storagectl STUFF --name "SCSICONTROLLER" --add scsi
vboxmanage storageattach "STUFF" --storagectl SCSICONTROLLER --type hdd \
--medium "`pwd`/stuff.vdi" --port 0 --device 0

vboxmanage modifyvm STUFF --ioapic on
vboxmanage modifyvm STUFF --memory 4096

vboxmanage modifyvm STUFF --nic1 nat --cableconnected1 on 
vboxmanage modifyvm STUFF --natpf1 SSH,tcp,,2222,,22

#vboxsdl --startvm STUFF
# Do the install, shut down

#vboxheadless -s STUFF &
