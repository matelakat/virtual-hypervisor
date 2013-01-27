openstack-at-home
=================
*Note: Under development, at the moment no openstack bits are installed,
Just XCP/XenServer bits*

This repository is created to provide an easy way for installing a
XenServer/XCP based OpenStack cloud at home, for development purposes.

Requirements:

 - 64 bit machine, 64 bit operating system
 - KVM or VirtualBox

Download XCP
============
You can download manually the latest xcp distribution, or you could use the
script provided:

    ./scripts/download_hypervisor_iso.sh

If you would like to use a XenServer, please download the iso manually. The
important thing, is that there needs to be a file with the name:

    hypervisor.iso

Create a new Virtual Machine with XCP/XenServer Inside
======================================================
To create a new VM with XCP installed inside, all you have to do, is to run:

    ./create_virtual_hypervisor.sh

This installs XCP on a KVM hypervisor. Should you wish to use VirtualBox,
specify the virtualbox option:

    ./create_virtual_hypervisor.sh virtualbox

As the script is finished, you should have a vm, with XCP installed inside. To
start the vm, for the kvm case, you should type:

    ./scripts/kvm_start_vm.sh

In the VirtualBox case, go to the UI, and start the VM there. In both cases
the ssh port of the VM is forwarded to the host's 2222 port.

What is the Password?
=====================
The password for the root user is (look at data/answers.txt):

    somepass

Uninstall
=========
Run:

    ./teardown.sh

This will remove the VM, and the generated iso.

Some Measurements
=================

VirtualBox:

    time scripts/start_vm_and_wait_for_shut.sh

    real    5m57.379s
    user    0m23.965s
    sys     4m4.603s

KVM:

    time scripts/kvm_start_vm_with_cdrom.sh

    real    5m34.585s
    user    2m47.986s
    sys     1m13.957s
