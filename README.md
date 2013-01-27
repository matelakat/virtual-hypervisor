openstack-at-home
=================
*Note: Under development, at the moment no openstack bits are installed,
Just XCP/XenServer bits*

This repository is created to provide an easy way for installing a
XenServer/XCP based OpenStack cloud at home, for development purposes.

Requirements:

 - 64 bit machine, 64 bit operating system
 - VirtualBox

Create a new Virtual Machine for XenServer
==========================================
To create a new VM with XCP installed inside, all you have to do, is to run:

    ./setup.sh

As the script is finished, you should have a virtualbox vm, called STUFF.
Simply start that VM, and ssh to localhost:2222 for the ssh console.

Performed Steps:

- downloads the XCP iso, if needed
- remasters the iso, so answerfile, adds answerfile, postinstall, firstboot
  scripts
- create a virtualbox vm, vm 22 forwarded to localhost:2222
- attach the created iso
- start the vm. At this point, the VM starts, does the xenserver installation,
  reboots, and after that, the firstboot script shuts down the machine.
- detach the custom iso - in order to prevent booting to it again.

Uninstall
=========
Run:

    ./teardown.sh

This will remove the VM, and the generated iso.
