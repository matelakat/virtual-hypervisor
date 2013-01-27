#!/bin/bash
set -eux

case "${1-kvm}" in
  "virtualbox" )
scripts/download_hypervisor_iso.sh

scripts/create_customxs_iso.sh

scripts/create_vm.sh

scripts/attach_customxs_iso.sh

scripts/start_vm_and_wait_for_shut.sh

scripts/detach_customxs_iso.sh
;;
  "kvm" )
scripts/download_hypervisor_iso.sh

scripts/create_customxs_iso.sh

scripts/kvm_create_harddisk.sh

scripts/kvm_start_vm_with_cdrom.sh
;;
  * )
echo "ERROR: Please specify hypervisor to use (kvm or virtualbox)"
exit 1
;;

esac

echo "XCP Setup completed"
