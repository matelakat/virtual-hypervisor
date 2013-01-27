#!/bin/bash

echo "Virtual machine started, to view console, use vncviewer :1"
kvm -net nic -net user,hostfwd=tcp:127.0.0.1:2222-:22 -enable-kvm -m 4192 -vnc :1 -boot c stuff.qcow
