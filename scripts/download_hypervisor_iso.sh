#!/bin/bash
set -eux

[ -e hypervisor.iso ] && echo "hypervisor.iso already downloaded" ||
wget -O hypervisor.iso http://downloads.xen.org/XCP/61809c/XCP-1.6-61809c.iso
