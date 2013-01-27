#!/bin/bash
set -eux

while ! vboxmanage unregistervm "STUFF" --delete;
do
    vboxmanage controlvm "STUFF" poweroff || true
    sleep 1;
done
