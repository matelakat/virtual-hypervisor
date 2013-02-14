#!/bin/bash
set -eu

function print_usage_and_quit
{
cat << USAGE >&2
usage: $(basename $0) NETWORK_NAME MACHINE_NAME

Start a VM with the name MACHINE_NAME on the network called NETWORK_NAME,
proceeding an automatic xenserver installation.

Positional arguments:
 NETWORK_NAME - the network to connect to
 MACHINE_NAME - a name for the machine
USAGE
exit 1
}

NETWORK_NAME="${1-$(print_usage_and_quit)}"
MACHINE_NAME="${2-$(print_usage_and_quit)}"

REPODIR=$(mktemp -d)

mv customxs.iso "$REPODIR/"

SR=$(xe sr-create name-label=CUSTOMXSISO type=iso device-config:location="$REPODIR" device-config:legacy_mode=true content-type=iso)
PBD=$(xe pbd-list sr-uuid=$SR --minimal)

# VM install
VXS=$(xe vm-install template="Other install media" new-name-label="$MACHINE_NAME - created (Step 1 of 3)")
NETWORK=$(xe network-list name-label="$NETWORK_NAME" --minimal)
MEM="6GiB"

# Networking
xe vif-create vm-uuid=$VXS network-uuid=$NETWORK device=0

# Memory
xe vm-memory-limits-set uuid=$VXS static-min=$MEM dynamic-min=$MEM dynamic-max=$MEM static-max=$MEM

# Disk
xe vm-disk-add disk-size=80GiB uuid=$VXS device=0

# CD
xe vm-cd-add cd-name=customxs.iso uuid=$VXS device=1

# First-time start
xe vm-param-set uuid=$VXS actions-after-reboot=Destroy
xe vm-start uuid=$VXS
xe vm-param-set uuid=$VXS name-label="$MACHINE_NAME - booted from iso (Step 2 of 3)"

# Wait for shut
while ! xe vm-param-get param-name=power-state uuid=$VXS | grep halted; do sleep 1; done

# Set back normal behavior
xe vm-param-set uuid=$VXS actions-after-reboot=Restart

# Start again, so install completes
xe vm-start uuid=$VXS
xe vm-param-set uuid=$VXS name-label="$MACHINE_NAME - first boot (Step 3 of 3)"

# Get rid of ISO SR
xe pbd-unplug uuid=$PBD
xe sr-forget uuid=$SR

rm -rf "$REPODIR"

# Wait for shut
while ! xe vm-param-get param-name=power-state uuid=$VXS | grep halted; do sleep 1; done
