#!/bin/bash
set -eux

vboxmanage list vms | grep "STUFF" || exit 0

while ! vboxmanage unregistervm "STUFF" --delete;
do
    vboxmanage controlvm "STUFF" poweroff || true
    sleep 1;
done
