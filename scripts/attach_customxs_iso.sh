#!/bin/bash
set -eux

vboxmanage storagectl STUFF --name "IDECONTROLLER" --remove || true
vboxmanage storagectl STUFF --name "IDECONTROLLER" --add ide
vboxmanage storageattach "STUFF" --storagectl IDECONTROLLER --type dvddrive \
--medium "`pwd`/customxs.iso" --port 0 --device 0

