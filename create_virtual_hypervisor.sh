#!/bin/bash
set -eux

case "${1-kvm}" in
  "virtualbox" )
scripts/virtualbox_create_vm.sh

scripts/virtualbox_attach_customxs_iso.sh

scripts/virtualbox_start_vm_and_wait_for_shut.sh

scripts/virtualbox_detach_customxs_iso.sh
;;
  "kvm" )
scripts/kvm_create_harddisk.sh

scripts/kvm_start_vm_with_cdrom.sh "customxs.iso"
;;
  * )
echo "ERROR: Please specify hypervisor to use (kvm or virtualbox)"
exit 1
;;

esac

echo "XCP Setup completed"
