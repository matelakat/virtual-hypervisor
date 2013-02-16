Virtual Hypervisor
==================
Scripted way for installing a virtual XenServer/XCP hypervisor.

Requirements:

 - 64 bit machine, 64 bit operating system (tested on Ubuntu 12.04)
 - XCP/XenServer or KVM or VirtualBox
 - Ubuntu packages: `p7zip-full genisoimage fakeroot`

Download XCP
============
You can download manually the latest xcp distribution, or you could use the
script provided to download XCP 1.6 :

    ./scripts/download_hypervisor_iso.sh

If you would like to use a XenServer, please download the iso manually.

Create a Custom XenServer/XCP iso
=================================
Generate an Answerfile
----------------------
The answerfile could be generated to the standard output, by:

    ./scripts/generate_answerfile.sh dhcp > answers

### Static IP example
This example should work with KVM

    ./scripts/generate_answerfile.sh static -h myvirtserv -i 10.0.2.69 -m 255.255.255.0 -g 10.0.2.2 > answers

Please run `scripts/generate_answerfile.sh` to see the various options available.

Generate the ISO
----------------
Remaster a XenServer/XCP iso, so that it installs automatically. Specify the
downloaded iso file, the target iso, and the answerfile

    ./scripts/create_customxs_iso.sh hypervisor.iso customxs.iso answers

Create and Start the Virtual Hypervisor
=======================================
On XenServer/XCP (Recommended)
------------------------------
Given, your network's name is `net` and your xenserver  host is
`xshost.somedomain`, and you want to give the name `VMH1` to your new virtual
hypervisor, you should type:

    scripts/xs_start_create_vm_with_cdrom.sh customxs.iso xshost.somedomain net VMH1

After this, you'll have a virtual hypervisor installed with the name `VMH1`.
    
On VirtualBox or KVM
--------------------
There are simple scripts, which assume, you have `customxs.iso` in your working
directory, and use that to install a hypervisor.

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
