#!/bin/bash
set -eux
wget -O "$1" http://releases.ubuntu.com/precise/ubuntu-12.04.2-alternate-amd64.iso
md5sum "$1" | grep -q cff39ccc589c7797aacce9efee7b5f93
