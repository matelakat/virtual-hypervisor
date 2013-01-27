#!/bin/bash
set -eux

kvm -enable-kvm -m 4192 -cdrom customxs.iso -vnc :1 -boot d stuff.qcow
