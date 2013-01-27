#!/bin/bash
set -eux

vboxmanage storagectl STUFF --name "IDECONTROLLER" --remove
