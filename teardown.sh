#!/bin/bash
set -eux

scripts/kvm_delete_harddisk.sh

scripts/delete_vm.sh

scripts/delete_customxs_iso.sh

