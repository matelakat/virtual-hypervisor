openstack-at-home
=================
This repository contains all the scripts, notes, information that could be useful
for installing a XenServer based OpenStack cloud at home.

Requirements:
- 64 bit machine, 64 bit operating system
- VirtualBox

Create a new Virtual Machine for XenServer
==========================================
- see http://blogs.citrix.com/2011/01/23/xenserver-in-virtualbox/
- NAT networking used (default)
- Simple IDE controller (default) with an 80 G disk
- "Enable IO APIC" is checked for virtual machine
- 4096M of RAM, 1 CPU
- Port forwarding: Guest 22 -> Host $XSPORT

Install XenServer
=================
- Select "thin provisioning"
- Make a note of your xenserver pass -> $XSPASS
