#!/bin/bash
set -eux

function print_usage_and_quit
{
cat << USAGE >&2
usage: $(basename $0) ISOFILE

Boot the virtual hypervisor from the specified ISOFILE.

Positional arguments:
 ISOFILE - A CD/DVD ISO image
USAGE
exit 1
}

ISOFILE="${1-$(print_usage_and_quit)}"

kvm -enable-kvm -m 4096 -cdrom "$ISOFILE" -vnc :1 -boot d stuff.qcow
