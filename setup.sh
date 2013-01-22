#!/bin/bash

vboxmanage createvm --name "STUFF" --register
vboxmanage storagectl STUFF --name "IDECONTROLLER" --add ide
vboxmanage storageattach "STUFF" --storagectl IDECONTROLLER --type dvddrive --medium "`pwd`/XCP-1.6-61809c.iso" --port 0 --device 0

vboxmanage createhd --filename "`pwd`/stuff.vdi" --size=20000
vboxmanage storagectl STUFF --name "SCSICONTROLLER" --add scsi
vboxmanage storageattach "STUFF" --storagectl SCSICONTROLLER --type hdd --medium "`pwd`/stuff.vdi" --port 0 --device 0

vboxmanage modifyvm STUFF --ioapic on
vboxmanage modifyvm STUFF --memory 2048

vboxmanage modifyvm STUFF --nic1 nat --cableconnected1 on 
vboxmanage modifyvm STUFF --natpf1 SSH,tcp,,2222,,22

vboxsdl --startvm STUFF
# Do the install, shut down

vboxmanage storagectl STUFF --name "IDECONTROLLER" --remove

vboxheadless -s STUFF &
