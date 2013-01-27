#!/bin/bash

scripts/download_hypervisor_iso.sh

scripts/create_customxs_iso.sh

scripts/create_vm.sh

scripts/attach_customxs_iso.sh
