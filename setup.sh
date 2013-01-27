#!/bin/bash
set -eux

scripts/download_hypervisor_iso.sh

scripts/create_customxs_iso.sh

scripts/create_vm.sh

scripts/attach_customxs_iso.sh

scripts/start_vm_and_wait_for_shut.sh

scripts/detach_customxs_iso.sh

echo "XCP Setup completed"
