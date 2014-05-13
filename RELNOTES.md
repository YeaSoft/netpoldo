==============================================================================
Release Notes - NetPoldo Rescue System - Version 49                 2013-03-14
==============================================================================

* Release Scope
* What's New
* Shipped Versions
* Included Software
* Memory Impact
* Known Problems
* Release History

Release Scope
-------------
This is the sixth experimental release of NetPoldo. Other than the previous
releases, which came with a plenty of highlights, this release is intended
mainly as a consolidation and upstream release and contains only a handful
of small improvements and the long awaited update to current versions after
10 months of inactivity.

As a premiere, this release includes the first edition of netpoldo for
Debian 7 (wheezy).

The deliveries of this version include both the ubuntu based version for
8.04, 10.04 and 12.04 and Debian Squeeze and Wheezy all as amd64 and i386.


What's new
----------
 * Support for Debian Wheezy 7.0.0
 * UIC updated to version 0.15


Shipped Versions
----------------

The following versions of NetPoldo are available for download:

Base OS                 | Platform | Archive
========================+==========+==========================================
Debian 7 "wheezy"       | i386     | netpoldo-debian-07.0.0-49-i386.tar.gz
------------------------+----------+------------------------------------------
Debian 7 "wheezy"       | amd64    | netpoldo-debian-07.0.0-49-amd64.tar.gz
------------------------+----------+------------------------------------------
Debian 6 "squeeze"      | i386     | netpoldo-debian-06.0.7-49-i386.tar.gz
------------------------+----------+------------------------------------------
Debian 6 "squeeze"      | amd64    | netpoldo-debian-06.0.7-49-amd64.tar.gz
------------------------+----------+------------------------------------------
Ubuntu 12.04 "precise"  | i386     | netpoldo-ubuntu-12.04.2-49-i386.tar.gz
------------------------+----------+------------------------------------------
Ubuntu 12.04 "precise"  | amd64    | netpoldo-ubuntu-12.04.2-49-amd64.tar.gz
------------------------+----------+------------------------------------------
Ubuntu 10.04 "lucid"    | i386     | netpoldo-ubuntu-10.04.4-49-i386.tar.gz
------------------------+----------+------------------------------------------
Ubuntu 10.04 "lucid"    | amd64    | netpoldo-ubuntu-10.04.4-49-amd64.tar.gz
------------------------+----------+------------------------------------------
Ubuntu 8.04 "hardy"     | i386     | netpoldo-ubuntu-08.04.4-49-i386.tar.gz
------------------------+----------+------------------------------------------
Ubuntu 8.04 "hardy"     | amd64    | netpoldo-ubuntu-08.04.4-49-amd64.tar.gz



Included Software
-----------------

In addition to the minimal system (ubuntu-minimal), the following additional
packages are included in this version of NetPoldo:

 * Connectivity and Usability
   + ssh
   + nano
   + screen

 * File Systems
   + nfs-common
   + ntfs-3g
   + sshfs

 * File System and Volume Tools
   + syslinux(*)
   + mdadm
   + squashfs-tools
   + open-iscsi
   + parted

 * Installation and deployment tools
   + partimage (**)
   + uic

(*)  including extlinux also in ubuntu 12.04
(**) not included in netpoldo-1004-64 because the package partimage is not
     available for amd64 in this version of ubuntu

A complete package list is included as package-list.txt in each distribution
archive. At runtime the user is able to install additional software in the
live system by using the standard means of ubuntu:

	apt-get update
	apt-get install <package>

Issuing apt-get update is mandatory, since the live filesystem does not
contain any package source listing in order to save as much as possible
memory.


Memory Usage
------------

The following memory usage values have been determined approximatively one
minute after completion of the boot process based on the selected NetPoldo


Version              | Local  | Integrated | Net    | Casper
=====================+========+============+========+========
Debian 7 - i386      |  81.4M |     181.1M |  81.6M |  n/a
---------------------+--------+------------+--------+--------
Debian 7 - amd64     | 100.3M |     201.4M | 103.0M |  n/a
---------------------+--------+------------+--------+--------
Debian 6 - i386      |  70.3M |     152.9M |  77.7M |  n/a
---------------------+--------+------------+--------+--------
Debian 6 - amd64     |  88.9M |     173.0M |  96.4M |  n/a
---------------------+--------+------------+--------+--------
Ubuntu 12.04 - i386  |  93.9M |     186.2M |  92.9M |  n/a
---------------------+--------+------------+--------+--------
Ubuntu 12.04 - amd64 | 113.4M |     207.8M | 117.7M |  n/a
---------------------+--------+------------+--------+--------
Ubuntu 10.04 - i386  |  78.2M |     164.4M |  76.3M |  n/a
---------------------+--------+------------+--------+--------
Ubuntu 10.04 - amd64 | 111.0M |     199.1M | 109.7M |  n/a
---------------------+--------+------------+--------+--------
Ubuntu 8.04 - i386   |  66.2M |     124.7M |  60.7M |  n/a
---------------------+--------+------------+--------+--------
Ubuntu 8.04 - amd64  |  84.5M |     143.2M |  80,3M |  n/a


The following method was used:

  echo $(($(grep MemTotal /proc/meminfo | awk '{print $2}') - \
    $(grep MemFree /proc/meminfo | awk '{print $2}') ))


Known Problems
--------------

At now there are no known issues with the current shipped configurations. In
order to satisfy the need of the extended functionality of some users, an
initial ramdisc based on casper is planned in a future release.


Release History
---------------

Version 47 released on 2012-06-05

 * Additional package syslinux
 * UIC updated to version 0.15
 * Improvements in the handling of root passwords

Version 45 released on 2012-05-14

 * Support for Debian Squeeze 6.0.5

Version 43 released on 2012-04-29

 * Final version of Ubuntu 12.04 LTS
 * Included uic - the Ubuntu Installation Creator

Version 41 released on 2012-04-17

 * Support for autodetection of the device with the filesystem containing
   the compressed root filesystem. Autodetection is enabled by specifying
   root=/dev/detect on the kernel commandline
 * New tool memused

Version 39 released on 2012-03-31

 * First public release containing the ubuntu based versions of
   8.04, 10.04 and the beta of 12.04 both for amd64 and x86.