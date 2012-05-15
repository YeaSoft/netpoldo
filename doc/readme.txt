==============================================================================
NetPoldo Rescue System - Version 45
==============================================================================

     NetPoldo is a lightweight Debian family live system intended for
     rescue, maintenance or installation purposes. It is delivered as
     easy to use components for PXE or simple boot system solutions and
     is available both for the i386 architecture as for the amd64 based
     on some Ubuntu and Debian versions.

Motivation
==========

Does this sound similar to the Ubuntu_Rescue_Remix? Yes. It does. But there are
fundamental differences that make it interesting to give NetPoldo a chance.

As stated in the project description, Ubuntu Rescue Remix is intended as "a
robust yet lean system for data recovery and forensics. No graphical interface
is used; the live system can boot and function normally on machines with very
little memory or processor power. Following Ubuntu's six-month release
schedule, all the software is up-to-date, stable and supported."

For this reason, the system is designed as a life system, to be booted mainly
from a physical media with the operator sitting at the console of the computer.
It is implemented using casper, the standard Debian and Ubuntu mechanism for
live systems.

NetPoldo, as the name suggests, was mainly inspired by the author's need of
having a small, reliable, simple to implement and fully ubuntu-compatible
system - bootable from network, from machines where the operator has no
physical access, without having to implement complex things like NFS Servers,
customized root file systems, handling of multiple usage conflicts, etc...

Let's say a real multipurpose rescue system for datacenter usage with
possibilities of usage specific customization (like setting a unique password
for a specific boot of a specific machine)

Although the original version of NetPoldo (based on Ubuntu 7.04, 32 and 64 bit)
was laboriously hand-crafted resulting in a specimen intended only for personal
use, it proved to be such a useful tool that there was the wish to produce new
releases and specific versions.

This finally led to a new project, with public releases, a documented and
reproducable build mechanism and documentation.

The current versions of NetPoldo are produced with UIC (The Ubuntu Installation
Creator), a toolkit that permits to create and maintain customized simple
debian-based operating system packages. The advantage of using this method are:

    * reproducability of results
    * automated production
    * automated updates
    * very simple customization
    * very simple creation of derived works


Highlights
==========

Three completely different boot strategies
------------------------------------------

    * Integrated Boot: 2 files. Only the linux kernel and an initial ramdisk
      image containing the whole, compressed root filesystem. This is the
      easiest way to use NetPoldo. If used to boot a system in a network
      environment, a DHCP and a TFTP Server are enough. If used to boot from a
      media, no media access is required after the system has started. The
      drawback: the computer must have enough memory (let's say at least 512MB)

    * Standard Boot: 3 files. The linux kernel, the initial ramdisk image and
      the compressed squashfs root file system. This strategy is less memory
      consuming (it runs also on systems with < 512MB RAM) and requires the
      root filesystem image to be accessible from a physical media for the
      whole runtime

    * Network Boot: 3 files. Basically identical to the standard boot with the
      difference that the compressed root filesystem will be loaded from an NFS
      share. This permits to boot NetPoldo on systems with low memory
      completely from the network.


Configurable from the boot command line
---------------------------------------

In addition to the standard Debian/Ubuntu kernel parameters, there are some
additional parameters that permit to influence the functionality of NetPoldo.
It is possible to modify the network login password, the keyboard layout and
also external persistant storage can be specified.


Availability of several flavours
--------------------------------

Currently the following ready made distributions are available:

Name          | Based on                    | Architecture
--------------+-----------------------------+---------------
netpoldo-deb6 | Debian 6.0.5 (squeeze)      | i386, amd64
netpoldo-1204 | Ubuntu 12.04 LTS (precise)  | i386, amd64
netpoldo-1004 | Ubuntu 10.04 LTS (lucid)    | i386, amd64
netpoldo-0804 | Ubuntu 8.04 LTS (hardy)     | i386, amd64

Since the concept of automated production based on UIC makes it really simple
to create derivative works, more flavours (e.g. based on debian or other
architectures) may be released in future.


Simple to update
----------------

Although the official NetPoldo binaries will be updated on a more or less
regular basis, thanks to UIC every user can produce without any effort his own
up to date binaries without any knowledge about the inner workings. After
installing UIC (that is composed of less that 10 script files) the following 3
commands would produce a fresh, up to date version of NetPoldo:

uic prepare netpoldo-1004-32
uic create netpoldo-1004-32
uic build netpoldo-1004-32


Simple to customize
-------------------

You want to create customized versions of NetPoldo? You can! Thanks to UIC you
have two approaches to do so:

   1. The interactive approach: this requires only the knowledge about your
      customizations. e.g.: you want to create a version with additional
      software. The only thing you need to know is how to install the software
      (apt-get install) and how to customize it if you want (e.g. by modifiying
      the configuration files). As long as you keep your UIC environment, you
      will be able to create up to date versions of your customized NetPoldo.

   2. The derivative work approach: this requires additionally some knowledge
      about UIC. You will create a new UIC template based on the original
      NetPoldo templates. With this (redistributable) template you can
      automatically create and keep up to date new NetPoldo-like systems
      containing every customization you want.


Versioning
==========

The deliverables of NetPoldo use the following versioning scheme:

        NetPoldo XX.YY.ZZ-NN

XX, YY and ZZ are the upstream version numbers of the originating operating
system, NN is the version number of the NetPoldo implementation

Samples:

Name                    | Description
------------------------+-----------------------------------------------------
NetPoldo 10.04.3-22     | Based on Ubuntu 10.04 LTS revision 4, NetPoldo
                        | Version 22
NetPoldo 12.04.BETA-39  | Based on Ubuntu 12.04 Beta, NetPoldo Version 39

The build date of a NetPoldo distribution is recorded inside NetPoldo. The motd
file (/etc/motd) gives information about the date and time of the last update.
Additionally all versioning and identification information is contained inside
NetPoldo in /etc/uictpl.conf as environment variables.


Usage
=====

The following files are part of NetPoldo. All other files contained in the
distribution archive are only intended for sample or documentation.

netpoldo.vmlinuz   This is the Linux kernel used for NetPoldo
netpoldo.initrd    This is the standard (local) version of the initial ramdisk
netpoldo.initrdi   This is the integrated version of the initial ramdisk
netpoldo.initrdn   This is the network enabled version of the initial ramdisk
netpoldo.squashfs  This is the compressed root file system


NetPoldo Command Line Parameters
--------------------------------

The following options may or must be specified on the kernel command line.

Parameter                         Description
---------------------------------+------------------------------------------
                                  This option sets the password for the user
                                  root. On the console there is no need to know
password=<password>               this password, since the consoles go directly
                                  into the shell. The password is useful when
                                  logging in via SSH. The default password is
                                  password

                                  This option sets the keyboard layout for the
                                  consoles. NetPoldo supports only 5 basic
                                  keyboard layouts:
keyboard=<layout>                     * us: United States
                                      * de: German
                                      * it: Italian
                                      * fr: French
                                      * es: Spanish

                                  This option sets the writable device for the
                                  filesystem writes during the NetPoldo
                                  runtime. It can be a physical filesystem
                                  formatted with ext2, ext3 or any filesystem
                                  supported by the initial ramdisk or a ramdisk
                                  itself (use /dev/ram to specify the ramdisk).
                                  When using the ramdisk, all changes made
branch=<device>                   during the session are lost after shutting
                                  down. It is permitted to reference the device
                                  by device name (e.g. /dev/sda1), by volume
                                  label (e.g. LABEL=boot-disk) and by unique
                                  volume id (e.g. UUID=f5a49b89-e8c7-448a-a920-
                                  ae0aaac53b7b) Depending upon the intial
                                  ramdisk image, this parameter may be optional
                                  or not. See below.

                                  This option sets the path and name to the
loop=<root filesystem image file> compressed root filesystem image. Depending
                                  upon the intial ramdisk image, this parameter
                                  may be optional or not. See below.

                                  This option sets the device for the
                                  filesystem where the compressed root
                                  filesystem image is located. It can be a
                                  physical filesystem formatted with ext2,
                                  ext3, any filesystem supported by the initial
                                  ramdisk, an NFS mount (use /dev/nfs to
root=<root fs device>             specify the NFS mount) or autodetection of a
                                  local or removable device (use /dev/detect).
                                  It is permitted to reference the device by
                                  device name (e.g. /dev/sda1), by volume label
                                  (e.g. LABEL=boot-disk) and by unique volume
                                  id (e.g.
                                  UUID=f5a49b89-e8c7-448a-a920-ae0aaac53b7b)
                                  Depending upon the intial ramdisk image, this
                                  parameter may be optional or not. See below.


Mandatory Command Line Parameters
---------------------------------

Based on the used initial ramdisk image, some parametrs may be mandatory or
not:

Initial Ramdisk  Required Parameters
----------------+-------------------------------------------------------------
netpoldo.initrd  The local initial ramdisk image requires all the root, the
                 loop and the branch parameters.

                 The integrated initial ramdisk image requires no parameters.
netpoldo.initrdi It is allowed to use the branch parameter in order to specify
                 a persistent storage volume. If not specified, it defaults to
                 /dev/ram

                 The network initial ramdisk image requires all the 'root', the
netpoldo.initrdn loop and the branch parameter. In addition it requires the
                 nfsroot parameter to point to the NFS share containing the
                 compressed root filesystem image and the ip parameter


Samples
=======

All following samples show boot scenarios based on syslinux configuration
files.


Simple integrated boot
----------------------

KERNEL   netpoldo.vmlinuz
APPEND   initrd=netpoldo.initrdi

Boots NetPoldo with default settings (US Keyboard, root password="password",
non persistent storage) from a physical volume with syslinux or PXE via TFTP


Boot from removable volume
--------------------------

KERNEL  /netpoldo-1004/i386/netpoldo.vmlinuz
APPEND  initrd=/netpoldo-1004/i386/netpoldo.initrd root=/dev/detect \
        loop=/netpoldo-1004/i386/netpoldo.squashfs branch=/dev/ram \
        password="aBRAcadaBRA"

Boots NetPoldo from a removable device where all files of NetPoldo are located
in the directory /netpoldo-1004/i386/. All writes are done in the ramdisk, so
there is no persistent storage. The password of the user root is set
to aBRAcadaBRA


Boot from local known volume
----------------------------

KERNEL  /netpoldo-1004/i386/netpoldo.vmlinuz
APPEND  initrd=/netpoldo-1004/i386/netpoldo.initrd root=LABEL=workstation-boot \
        loop=/netpoldo-1004/i386/netpoldo.squashfs branch=/dev/ram \
        password="aBRAcadaBRA"

Boots NetPoldo from the device with the volume name workstation-boot where all
files of NetPoldo are located in the directory /netpoldo-1004/i386/. All writes
are done in the ramdisk, so there is no persistent storage. The password of the
user root is set to aBRAcadaBRA


Boot from Network with NFS
--------------------------

KERNEL   netpoldo-1004/i386/netpoldo.vmlinuz
APPEND   initrd=netpoldo-1004/i386/netpoldo.initrdn rootdelay=2 root=/dev/nfs \
         nfsroot=10.65.6.1:/mnt/data/tftproot,rw ip=dhcp \
         loop=/yeaboot/netpoldo-1004/i386/netpoldo.squashfs branch=/dev/ram \
         keyboard=de

PXE Boot of NetPoldo via TFTP with the kernel and the initial ramdisk located
in the directory netpoldo-1004/i386 of the TFTP server area. The compressed
root filesystem image is located on the NFS share /mnt/data/tftproot on the
server with the address 10.65.6.1 in the directory /yeaboot/netpoldo-1004/
i386/. The IP address of the booting computer is assigned by DHCP. All writes
are done in the ramdisk, so there is no persistent storage. The default
keyboard layout is set to german.


How NetPoldo works
==================

This really important chapter will be updated in the next release of the
distribution.


Creating your own NetPoldo
==========================

Since UIC - the production tool used for NetPoldo is still in development and
not available to public, the documentation has to wait for the release of UIC


Copyright and Legal Stuff
=========================

NetPoldo is a derivative work based on Debian and Ubuntu Linux created by Leo
Moll <leo.moll@yeasoft.com>

Copyright: 2012 Leo Moll <leo.moll@yeasoft.com>

 This package is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This package is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.  

 You should have received a copy of the GNU General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>
