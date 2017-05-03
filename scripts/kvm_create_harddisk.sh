#!/bin/bash
set -eux

qemu-img create -f qcow2 stuff.qcow 50G
