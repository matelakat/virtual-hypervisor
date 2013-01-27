#!/bin/bash
set -eux

vboxmanage controlvm "STUFF" poweroff || true

while ! vboxmanage showvminfo "STUFF" | grep -q "powered off";
do
    echo "Waiting for machine to shut down"
    sleep 1;
done

vboxmanage unregistervm "STUFF" --delete
