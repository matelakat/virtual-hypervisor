#!/bin/bash

# Wait before start
sleep 60

# Disable first boot script for subsequent reboots
rm -f /etc/rc3.d/S99zzpostinstall

touch /tmp/firstboot.sh.executed

# Shut down the computer
halt -p
