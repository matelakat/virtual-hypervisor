#!/bin/bash
set -eux
wget -O "$1" http://mirror.as29550.net/releases.ubuntu.com/13.04/ubuntu-13.04-server-amd64.iso
md5sum "$1" | grep -q 7d335ca541fc4945b674459cde7bffb9
