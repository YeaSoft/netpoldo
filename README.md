NetPoldo Rescue System
======================

>    __NetPoldo__ is a lightweight Debian family live system intended for
     rescue, maintenance or installation purposes. It is delivered as
     easy to use components for PXE or simple boot system solutions and
     is available both for the _i386_ architecture as for the _amd64_
     based on some Ubuntu and Debian versions.

Motivation
----------

Does this sound similar to the [Ubuntu Rescue Remix](http://ubuntu-rescue-remix.org/)?
Yes. It does. But there are fundamental differences that make it worth to give
NetPoldo a try.

As stated in the project description, __Ubuntu Rescue Remix__ is intended as
"_a robust yet lean system for data recovery and forensics. No graphical
interface is used; the live system can boot and function normally on machines
with very little memory or processor power. Following Ubuntu's six-month release
schedule, all the software is up-to-date, stable and supported._"

For this reason, the system is designed as a life system, to be booted mainly
from a physical media with the operator sitting at the console of the computer.
It is implemented using __[live-boot](http://live.debian.net/)__ (also known as
_casper_), the standard Debian and Ubuntu mechanism for live systems.

_NetPoldo_, as the name suggests, was mainly inspired by the author's need of
having a small, reliable, simple to implement and fully Debian- /
Ubuntu-compatible system _bootable from network_, from machines where _the
operator has no physical access_, without having to implement complex things
like NFS Servers, customised root file systems, handling of multiple usage
conflicts, etc...
Let's say a real multipurpose rescue system for datacenter usage with
possibilities of usage specific customizations (like setting a unique password
for a specific boot sequence of a specific machine).

Although the original version of NetPoldo (based on Ubuntu 7.04, 32 and 64 bit)
was laboriously hand-crafted resulting in a specimen intended only for personal
use, it proved to be such a useful tool that there was the wish to produce new
releases and specific versions.

This finally led to a new project, with public releases, a documented and
reproducible build mechanism and documentation.

The current versions of NetPoldo are produced with
[UIC](http://www.yeasoft.com/site/projects:uic) (the __Unified Installation
Creator__), a toolkit that permits to create and maintain customised simple
Debian-based operating system packages. The advantages of using this method are:

   * reproducibility of results
   * automated production
   * automated updates
   * easy customisation
   * easy creation of derived works

Highlights
----------

### Three completely different boot strategies ###

   * __Integrated Boot: 2 files.__ Only the Linux kernel and an initial ramdisk
     image containing the whole, compressed root filesystem. This is the easiest
     way to use NetPoldo. If used to boot a system in a network environment, a
     DHCP and a TFTP Server are enough. If used to boot from a media, no media
     access is required after the system has been started. The drawback: the
     computer must have enough memory (at least 512MB).
   * __Standard Boot: 3 files.__ The Linux kernel, the initial ramdisk image and
     the compressed squashfs root file system. This strategy is less memory
     consuming (it runs also on systems with less than 512MB RAM) and requires
     the root filesystem image to be accessible from a physical media for the
     whole runtime.
   * __Network Boot: 3 files.__ Basically identical to the standard boot with
     the difference that the compressed root filesystem will be loaded from an
     NFS share. This permits to boot NetPoldo on systems with low memory
     completely from the network.

### Configurable from the boot command line ###

In addition to the standard kernel parameters supported by Debian and Ubuntu,
there are some additional parameters that permit to influence the functionality
of NetPoldo. It is possible to modify the network login password, the keyboard
layout and also external persistant storage can be specified.


### Availability of several flavours ###

Currently _NetPoldo_ is available in several flavours. Each flavour is based on
a specific Debian or Ubuntu version and architecture:

 Name          | Based on                    | Architecture
---------------|-----------------------------|--------------
 netpoldo-deb8 | Debian 8 Beta (jessie)      | i386, amd64
 netpoldo-deb7 | Debian 7.5.0 (wheezy)       | i386, amd64
 netpoldo-deb6 | Debian 6.0.9 (squeeze)      | i386, amd64
 netpoldo-1404 | Ubuntu 14.04 LTS (trusty)   | i386, amd64
 netpoldo-1204 | Ubuntu 12.04 LTS (precise)  | i386, amd64
 netpoldo-1004 | Ubuntu 10.04 LTS (lucid)    | i386, amd64
 netpoldo-0804 | Ubuntu 8.04 LTS (hardy)     | i386, amd64

Since the concept of automated production based on __UIC__ makes it really easy
to create derivative works, more flavours may be released in future.


### Easy to update ###

Although the official NetPoldo binaries will be updated on a more or less
regular basis, thanks to __UIC__ every user can produce without any effort his
own up to date binaries without any knowledge about the inner workings. After
installing __UIC__ the following few commands would produce a fresh, up to date
version of NetPoldo Wheezy i386:

````
uic get netpoldo-deb7-32
uic create netpoldo-deb7-32
uic build netpoldo-deb7-32
````


### Easy to customise ###

You want to create customized versions of NetPoldo? You can! Thanks to __UIC__
you have two approaches to do so:

   1. The interactive approach: this requires only the knowledge about your
      customisations. e.g.: you want to create a version with additional
      software.
      The only thing you need to know is how to install the software (`apt-get
      install`) and how to customize it if you want (e.g. by modifiying the
      configuration files). As long as you keep your UIC environment, you will
      be able to create up to date versions of your customised NetPoldo.
   2. The derivative work approach: this requires additionally some knowledge
      about UIC. You will create a new UIC template based on the original
      NetPoldo templates. With this (redistributable) template you can
      automatically create and keep up to date new NetPoldo-like systems
      containing every customisation you want.


Versioning
----------

The deliverables of NetPoldo use the following naming and versioning scheme:

````
netpoldo-DISTRO-UVER-NVER-ARCH.tar.gz
````

where _DISTRO_ is the name of the upstream distribution (e.g. debian), _UVER_
the upstream version numbers of the originating operating systen, _NVER_ is the
version number of the NetPoldo implementation and _ARCH_ the system architecture
(e.g. i386 or amd64).

The build date of a NetPoldo distribution is recorded inside NetPoldo. The motd
file (`/etc/motd`) gives information about the date and time of the last update.
Additionally all versioning and identification information is contained inside
NetPoldo in `/etc/uictpl.conf` as environment variables.


Usage
-----

The following files are part of NetPoldo. All other files contained in the
distribution archive are only intended for sample or documentation.

  * `netpoldo.vmlinuz` - The Linux kernel used for NetPoldo
  * `netpoldo.initrd` - The standard (local) version of the initial ramdisk
  * `netpoldo.initrdi` - The integrated version of the initial ramdisk
  * `netpoldo.initrdn` - The network enabled version of the initial ramdisk
  * `netpoldo.squashfs` - The compressed root file system

### Command Line Parameters ###

The following options __may__ or __must__ be specified on the kernel command
line.

  * `password=<password>` or `password=SHADOW:<hash value>`:
    This option sets the password for the user `root`. It can be specified as
    clear text or as a `/etc/shadow`-compatible hash value if prefixed with
    the word `SHADOW:`.
    On the console there is no need to know this password, since the
    consoles go directly into the shell. The password is useful when logging in
    via SSH. The default password is _"password"_.

  * `keyboard=<layout>`:
    This option sets the keyboard layout for the consoles. Basically every
    supported two letter code may work with Debian. On Ubuntu flavours, only
    the following keyboard layouts are supported:
    - cn: Chinese
    - de: German
    - es: Spanish
    - fr: French
    - gb: English United Kingdom
    - it: Italian
    - pt: Portoguese
    - ro: Romenian
    - ru: Russian
    - us: English United States

  * `timezone=<tzname>`:
    This option sets the timezone of the system. The timezone must be specified
    in the format `AREA/ZONE`. If not specified, the timezone is set to
    `Etc/UTC`.

  * `branch=<device>`:
    This option sets the writable device for the filesystem writes during the
    NetPoldo runtime. It can be a physical filesystem formatted with `ext2`,
    `ext3` or any filesystem supported by the initial ramdisk or a ramdisk
    itself (use `/dev/ram` to specify the ramdisk). When using the ramdisk, all
    changes made during the session are lost after shutting down. It is
    permitted to reference the device by device name (e.g. `/dev/sda1`), by
    volume label (e.g. `LABEL=boot-disk`) and by unique volume id (e.g.
    `UUID=f5a49b89-e8c7-448a-a920-ae0aaac53b7b`). Depending upon the initial
    ramdisk image, this parameter may be optional or not. See below.

  * `loop=<root filesystem image file>`:
    This option sets the path and name to the compressed root filesystem image.
    Depending upon the intial ramdisk image, this parameter may be optional or
    not. See below.

  * `root=<root fs device>`:
    This option sets the device for the filesystem where the compressed root
    filesystem image is located. It can be a physical filesystem formatted with
    `ext2`, `ext3`, any filesystem supported by the initial ramdisk, an NFS
    mount (use `/dev/nfs` to specify the NFS mount) or autodetection of a local
    or removable device (use `/dev/detect`). It is permitted to reference the
    device by device name (e.g. `/dev/sda1`), by volume label (e.g.
    `LABEL=boot-disk`) and by unique volume id (e.g.
    `UUID=f5a49b89-e8c7-448a-a920-ae0aaac53b7b`). Depending upon the initial
    ramdisk image, this parameter may be optional or not. See below.

Based on the used initial ramdisk image, some parametrs may be mandatory or
not:

  * `netpoldo.initrd`:
    The _local initial ramdisk image_ requires at least the `loop` and the
    `branch` parameters. If the `root` parameter is not specified, it defaults
    to `/dev/detect` and NetPoldo tries to find a volume containing the
    compressed root filesystem image as specified in `loop`.

  * `netpoldo.initrdi`:
    The _integrated initial ramdisk image_ requires no parameters. It is allowed
    to use the `branch` parameter in order to specify a persistent storage
    volume. If not specified, it defaults to `/dev/ram`.

  * `netpoldo.initrdn`:
    The _network initial ramdisk image_ requires at least the `loop` and the
    `branch` parameter. In addition it requires the `nfsroot` parameter to point
    to the NFS share containing the compressed root filesystem image and the
    `ip` parameter.


Samples
-------

All following samples show boot scenarios based on syslinux configuration
files.


### Simple integrated boot ###

````
KERNEL   netpoldo.vmlinuz
APPEND   initrd=netpoldo.initrdi
````

Boots NetPoldo with default settings (US Keyboard, root password set to
_"password"_, non persistent storage) from a physical volume with `syslinux`
or PXE via TFTP.


### Boot from removable volume ####

````
KERNEL  /netpoldo-deb7/i386/netpoldo.vmlinuz
APPEND  initrd=/netpoldo-deb7/i386/netpoldo.initrd \
        loop=/netpoldo-deb7/i386/netpoldo.squashfs branch=/dev/ram \
        password="aBRAcadaBRA"
````

Boots NetPoldo from a removable device where all files of NetPoldo are located
in the directory `/netpoldo-deb7/i386/`. All writes are done in the ramdisk, so
there is no persistent storage. The password of the user `root` is set
to _"aBRAcadaBRA"_.


### Boot from local known volume ###

````
KERNEL  /netpoldo-deb7/i386/netpoldo.vmlinuz
APPEND  initrd=/netpoldo-deb7/i386/netpoldo.initrd root=LABEL=workstation-boot \
        loop=/netpoldo-deb7/i386/netpoldo.squashfs branch=/dev/ram \
        password="aBRAcadaBRA"
````

Boots NetPoldo from the device with the volume name `workstation-boot` where all
files of NetPoldo are located in the directory `/netpoldo-deb7/i386/`. All
writes are done in the ramdisk, so there is no persistent storage. The password
of the user `root` is set to _"aBRAcadaBRA"_.


### Boot from Network with NFS ###

````
KERNEL   netpoldo-deb7/i386/netpoldo.vmlinuz
APPEND   initrd=netpoldo-deb7/i386/netpoldo.initrdn rootdelay=2 \
         nfsroot=10.65.6.1:/mnt/data/tftproot,rw ip=dhcp \
         loop=/yeaboot/netpoldo-deb7/i386/netpoldo.squashfs branch=/dev/ram \
         password="SHADOW:$6$uOaZn5oq$Ka6KFS3znhrcAIeDpYxJXhP0f8MEvuruHKzRMQKIQV2OMKfsIA7AsjvCe0Ray5VXTjA2MNoYO0Hia2MKBPHsc." \
         timezone="Europe/Berlin" keyboard=de
````

PXE Boot of NetPoldo via TFTP with the kernel and the initial ramdisk located
in the directory `netpoldo-deb7/i386` of the TFTP server area. The compressed
root filesystem image is located on the NFS share `/mnt/data/tftproot` on the
server with the address `10.65.6.1` in the directory
`/yeaboot/netpoldo-deb7/i386/`. The IP address of the booting computer is
assigned by DHCP. All writes are done in the ramdisk, so there is no persistent
storage. The time zone will be set to `Europe/Berlin`, the password set to the
encrypted representation of _"aBRAcadaBRA"_ and the default keyboard layout is
set to german.


Related Links
-------------

   * Download location for prebuilt binaries:
     http://www.yeasoft.com/downloads/netpoldo/
   * Project home page:
     http://www.yeasoft.com/site/projects:netpoldo
   * GitHub Repository:
     https://github.com/YeaSoft/NetPoldo

NetPoldo can be built from its templates using __UIC__, the Unified
Installation Creator. See the [project page][1] for further information.
 __UIC__ is also [hosted on GitHub][2].

[1]: http://www.yeasoft.com/site/projects:uic
[2]: https://github.com/YeaSoft/uic


Copyright and Legal Stuff
-------------------------

NetPoldo is a derivative work based on Debian and Ubuntu Linux created by Leo
Moll <leo.moll@yeasoft.com>

Copyright: 2012-2014 Leo Moll <leo.moll@yeasoft.com>

> This package is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

> This package is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

> You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>

