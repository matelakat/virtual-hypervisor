Virtual Hypervisor
==================
Scripted way for installing a virtual XenServer/XCP hypervisor.

Requirements:

 - 64 bit machine, 64 bit operating system (tested on Ubuntu 12.04)
 - KVM or VirtualBox

Download XCP
============
You can download manually the latest xcp distribution, or you could use the
script provided to download XCP 1.6 :

    ./scripts/download_hypervisor_iso.sh

If you would like to use a XenServer, please download the iso manually, and
place the downloaded iso to this directory, with the name `hypervisor.iso`

Create a Custom XenServer/XCP iso
=================================
Remaster the downloaded iso, so that it installs the hypervisor automatically.

    ./scripts/create_customxs_iso.sh

Create and Start a New VM with the Remastered iso
=================================================
To create a new VM with the remastered iso, all you have to do, is to run:

    ./create_virtual_hypervisor.sh

This installs the hypervisor on KVM. Should you wish to use VirtualBox, specify
the virtualbox option:

    ./create_virtual_hypervisor.sh virtualbox

As the script is finished, you should have a vm, with the hypervisor installed
inside. To start the vm, for the kvm case, you should type:

    ./scripts/kvm_start_vm.sh

In the VirtualBox case, go to the UI, and start the VM there. In both cases
the ssh port of the VM is forwarded to the host's 2222 port.

How Can I Access the Virtual Hypervisor?
========================================
The virtual hypervisor's ssh port is forwarded to your localhost's 2222 port.

    ssh -p 2222 root@localhost

What is the Password?
=====================
The password for the root user is (look at data/answerfile.xml):

    somepass

Uninstall
=========
Run:

    ./teardown.sh

This will remove the VM, and the generated iso.
