NetPoldo Rescue System - Release Notes
======================================

Release Scope
-------------

This is the seventh experimental release of NetPoldo. Other than the previous
releases, which came with a plenty of highlights, also this release is mainly
intended as a consolidation and upstream release and contains some useful
improvements, some new packages and the long awaited update to current
upstream versions of Debian and Ubuntu.

As a premiere, this release includes the first edition of netpoldo for Debian
8 Beta (jessie) and Ubuntu 14.04 (trusty). Since the repositories of Ubuntu
8.04 (hardy) are now offline, the corresponding version of netpoldo will not
be updated any more.


What's new in Version 51 (2014-05-16)
-------------------------------------
 * UIC updated to version 0.16.6
 * New software packages (see below)
 * New flavour based on Debian Jessie 8 Beta
 * New flavour based on Ubuntu Trusty 14.04


Shipped Versions
----------------

The following versions of NetPoldo are available for download:

````
  Base OS                 | Platform | Archive
 -------------------------|----------|-----------------------------------------
  Debian 8 "jessie"       | i386     | netpoldo-debian-8.0.0-51-i386.tar.gz
  Debian 8 "jessie"       | amd64    | netpoldo-debian-8.0.0-51-amd64.tar.gz
  Debian 7 "wheezy"       | i386     | netpoldo-debian-7.5.0-51-i386.tar.gz
  Debian 7 "wheezy"       | amd64    | netpoldo-debian-7.5.0-51-amd64.tar.gz
  Debian 6 "squeeze"      | i386     | netpoldo-debian-6.0.9-51-i386.tar.gz
  Debian 6 "squeeze"      | amd64    | netpoldo-debian-6.0.9-51-amd64.tar.gz
  Ubuntu 14.04 "trusty"   | i386     | netpoldo-ubuntu-14.04.0-51-i386.tar.gz
  Ubuntu 14.04 "trusty"   | amd64    | netpoldo-ubuntu-14.04.0-51-amd64.tar.gz
  Ubuntu 12.04 "precise"  | i386     | netpoldo-ubuntu-12.04.4-51-i386.tar.gz
  Ubuntu 12.04 "precise"  | amd64    | netpoldo-ubuntu-12.04.4-51-amd64.tar.gz
  Ubuntu 10.04 "lucid"    | i386     | netpoldo-ubuntu-10.04.4-51-i386.tar.gz
  Ubuntu 10.04 "lucid"    | amd64    | netpoldo-ubuntu-10.04.4-51-amd64.tar.gz
````


Included Software
-----------------

In addition to the minimal system, the following additional packages are
included in this version of NetPoldo:

 * Connectivity and Usability
   - dnsutils
   - host
   - ftp
   - ssh
   - rsync
   - screen
   - nano
   - lsof

 * File Systems
   - nfs-common
   - ntfs-3g
   - sshfs
   - dosfstools

 * File System and Volume Tools
   - syslinux including extlinux binary
   - mdadm
   - squashfs-tools
   - open-iscsi
   - dmsetup
   - parted
   - mtools
   - extundelete
   - recover (not included in Debian 8 and Ubuntu Trusty)
   - e2undel (not included in Debian 8 and Ubuntu Trusty)
   - chntpw

 * Installation and deployment tools
   - partimage (not included in netpoldo-1004-64 because the package
     is not available for amd64 in this version of Ubuntu)
   - uic

A complete package list is included as `package-list.txt` in each distribution
archive. At runtime the user is able to install additional software in the
live system by using the standard means of ubuntu:

````
apt-get update
apt-get install <package>
````

Issuing `apt-get update` is mandatory, since the live filesystem does not
contain any cached package source listing in order to save as much as possible
memory.


Memory Usage
------------

The following memory usage values have been determined approximatively one
minute after completion of the boot process based on the selected NetPoldo
image:


````
  Version              | Local  | Integrated | Net
 ----------------------|--------|------------|--------
  Debian 8 - i386      |  97.9M |     211.2M | 100.4M
  Debian 8 - amd64     | 120.4M |     232.5M | 123.4M
  Debian 7 - i386      |  82.8M |     183.4M |  84.1M
  Debian 7 - amd64     | 103.4M |     203.6M | 105.4M
  Debian 6 - i386      |  72.7M |     154.4M |  79.6M
  Debian 6 - amd64     |  91.4M |     174.7M |  98.0M
  Ubuntu 14.04 - i386  | 109.8M |     235.4M | 109.5M
  Ubuntu 14.04 - amd64 | 109.8M |     234.8M | 109.5M
  Ubuntu 12.04 - i386  |  92.0M |     190.4M |  90.9M
  Ubuntu 12.04 - amd64 | 118.7M |     220.4M | 116.4M
  Ubuntu 10.04 - i386  |  80.4M |     171.8M |  81.6M
  Ubuntu 10.04 - amd64 | 115.1M |     207.6M | 114.3M
````

The following method was used:

````
  echo $(($(grep MemTotal /proc/meminfo | awk '{print $2}') - \
    $(grep MemFree /proc/meminfo | awk '{print $2}') ))
````

Known Problems
--------------

At now there are no known issues with the currently shipped configurations.


Release History
---------------

### Version 49 released on 2013-03-14 ###

 * Support for Debian Wheezy 7.0.0
 * UIC updated to version 0.15

### Version 47 released on 2012-06-05 ###

 * Additional package syslinux
 * UIC updated to version 0.15
 * Improvements in the handling of root passwords

### Version 45 released on 2012-05-14 ###

 * Support for Debian Squeeze 6.0.5

### Version 43 released on 2012-04-29 ###

 * Final version of Ubuntu 12.04 LTS
 * Included uic - the Ubuntu Installation Creator

### Version 41 released on 2012-04-17 ###

 * Support for autodetection of the device with the filesystem containing
   the compressed root filesystem. Autodetection is enabled by specifying
   root=/dev/detect on the kernel commandline
 * New tool memused

### Version 39 released on 2012-03-31 ###

 * First public release containing the ubuntu based versions of
   8.04, 10.04 and the beta of 12.04 both for amd64 and x86.
