---
layout: post
title: 'Setup dm-verity on a minimal Debian installation'
comments: true
toc: true
---

# 1 - System installation
In order to make dm-verity works, it is needed that the system can work with a read-only root. 
As a playground a minimal debian installation on a VM can be used. At first create a VM with at least 10GB of space and install Debian. Download and connect to the machine debian-netinst, then start the VM and install Debian.
Pay attention to select "Separate /home /var and /tmp on partitions", as shown in the image below.

![Configure partition](/assets/images/dmverity/1%20-%20Install%20-%20Configure%20partitions.png){: .center-image}

In order to speed up the process, it is possible to leave all the default options in order to not install a desktop manager as shown in the image below.

![Install features](/assets/images/dmverity/2%20-%20Install%20-%20Features.png){: .center-image}

Once the system is installed, boot it.

# 2 - Move /boot to another partition
Once dm-verity will be activated, the kernel will need to have the root hash of the filesystem in order to verify that the system is integer. The root hash cannot be stored in the root partition, as it is indeed the result of the hashing of the root partition.

In order to make things works, a separate partition for the boot image is also needed. Alternatively, during installation, it is possible to configure a manual partition layout and specify from the beginning that ```/boot``` has to be in a different partition.

The most simple approach is to connect another disk to the virtual machine manager (500MB is enough). This guide will assume this is /dev/sdb.
Once connected the 2nd hard-disk, run:

```bash
# Get a shell as root 
sudo su -

# Make the partition /dev/sdb1
fdisk /dev/sdb
# Press, in order: n, p, 1, (enter), (enter), w
```

At the end the situation should be this:

![fdisk Output](/assets/images/dmverity/3%20-%20fdisk%20output.png){: .center-image}

Configure the partition and update ```fstab```:

```bash
# Format the partition with 
sudo mkfs.ext4 /dev/sdb1
# Mount the partition
mkdir new_boot
mount /dev/sdb1 ./new_boot
# Copy the content from /boot to ./new_boot, preserving permissions
cp -rp /boot/* ./new_boot/
# Appent the output of blkid /dev/sdb1 (containing the UUID of /dev/sdb1) to /etc/fstab
blkid /dev/sdb1 >> /etc/fstab
# Modify /etc/fstab to create a proper entry with this UUID
vim /etc/fstab
```

At this point, if the UUID of ```/dev/sdb1``` is ```a564f019-b80e-41c8-a993-05cf1369ad81```, ```/etc/fstab``` should look like this:

![fstab boot](/assets/images/dmverity/4%20-%20fstab%20-%20boot.png){: .center-image}

Once ```/etc/fstab``` is update, it is needed to reconfigure grub:

```bash
# Update grub with the right root and prefix
update-grub
# Install grub also to the disk that contains the /boot partition
grub-install /dev/sdb
```

The output should look like this:

![grun update](/assets/images/dmverity/5%20-%20Grub%20update.png){: .center-image}

To avoid a clash between the old /boot and the new boot:

```bash
# Rename /boot to /old_boot
mv /boot /old_boot
# Create a new directory that will be used by fstab/udev to mount the boot partition
mkdir /boot
```

At this point the system can be rebooted. The last step is to reconfigure the BIOS of the VM manager and make it try to boot the 2nd disk first of all.

After boot, you can make sure that everything is working by running the command mount without arguments.
The output should look like this:

![mount command](/assets/images/dmverity/6%20-%20Mount%20command.png){: .center-image width="1091" height="767"}

It can be seen that ```/dev/sdb1``` is mounted in ```/boot```.

# 3 - Recompile the kernel
In order to use as root a mapper device, it is needed to mount it before the init execution.

This can be done in 2 ways:

1. By altering the script /init of the initramfs to make it configure the mapper
2. By specifying a parameter to the kernel that will instruct the kernel to do everything by itself
In both cases, it is needed to recompile the component since by default neither busybox nor the kernel on a plain Debian 10 installation support what it is needed to create the device.

The most straightforward solution is to recompile the kernel so in the tutorial this is the method that will be used.

The kernel need to be upgraded from the version 4.* that Debian 10 is using, since the option that is needed is available starting from linux 5.1. It is possible to upgrade the kernel adding the backport repository to APT.

```bash
sudo su -

# Add buster-backports to sources.list and download/decompress kernel source code
echo deb https://deb.debian.org/debian buster-backports main >> /etc/apt/sources.list
sudo apt update
sudo apt install kernel-source-5.9 kernel-config-5.9
tar -xaf /usr/src/linux-source-5.9.tar.xz
cd linux-source-5.9

# Alternatively, just download the latest kernel from linux.org
https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.10.7.tar.xz
tar -xaf /usr/src/linux-5.10.7.tar.xz
cd linux-5.10.7

# At this point, either:
#    1) Use the Debian config (from kernel-config-5.9 package) that is very bloated, 
#       slow to compile and require a lot of space but require less tuning
zcat /usr/src/linux-config-5.9/config.amd64_none_amd64.xz >> ./.config
make oldconfig

# Or 2) Start from a default config and add what it is needed to make it bootable later
make x86_64_defconfig

# Install prerequisites to build the kernel
sudo apt-get install build-essential bc kmod cpio flex libncurses5-dev libelf-dev libssl-dev bison

# Open menuconfig
make menuconfig

# Find the following options in the menuconfig and change them as described:
#    Device Drivers → Multiple devices driver support (RAID and LVM) →  Device mapper support → change to * (YES)
#    Device Drivers → Multiple devices driver support (RAID and LVM) →  Device mapper support → DM "dm-mod.create=" paramter support → change to * (YES)
#    Device Drivers → Multiple devices driver support (RAID and LVM) →  Device mapper support → Verity target support → change to * (YES)
#    File systems → Miscellaneous filesystems → SquashFS 4.0 - Squashed file system support → change to * (YES)
# If you're starting from x86_64_defconfig, at this point add what you need to make the kernel work on your VM manager.
# For example on VM Ware 16 the SCSI controller driver is missing:
#    Device Drivers → Fusion MPT driver support → Change to * (YES)
#    Device Drivers → Fusion MPT driver support → Fusion MPT ScsiHost driver → Change to * (YES)
# Instead, if you started from debian config remember to disable change the following option:
#    Cryptographic API → Certificate for signature checking → Provide system-wide ring of trusted keys → Set it to ""

# Compile and install the new kernel
make -j8
sudo make modules_install
sudo make install
```

After this it is possible to reboot the system and make sure everything is working properly.

Optionally, at this point is possible to clean the system from temporary files and install/configure other tools, since starting from the next step the system will be read-only.

# 4 - root in read-only
At this point, it is needed to setup the root filesystem as read-only, in order to proceed with the activation of dm-verity. This section is divided into 2 parts, depending on 

# 4.1 - Root in read-only - squashfs (alternative to step 4.2)
In order to create a squashfs filesystem, boot from a live linux and mount the root filesystem and the home partition:

```bash
sudo su -
mkdir ./root
mkdir ./home
mount /dev/sda1 ./root
mount /dev/sda8 ./home
Install the tools that will be used:

apt update
apt install squashfs-tools cryptsetup-bin vim 
Create the squashfs image:

mksquashfs ./root ./home/root.squashfs
# Unsquash it again to make it easy to modify and repack the filesystem
cd home
unsquashfs ./root.squashfs
# Edit fstab to make it mount the squashfs partition as root
vim ./home/squashfs-root/etc/fstab
The squashfs image needs to be flashed somewhere. This place can be /dev/sda1 but in this case if there are some mistake, the system won't boot anymore. Another solution is to just create and plug another disk.
```

Supposing the chosen disk where to flash the image is ```/dev/sda1```, fstab will look like this:

![fstab squashfs](/assets/images/dmverity/7%20-%20fstab%20-%20squashfs.png){: .center-image}

Now it is possible to repack the image again and flash it:

```bash
rm root.squashfs
mksquashfs ./squashfs-root/ ./root.squashfs
dd if=./root.squashfs of=/dev/sda1
sync
```

# 4.2 - Root in read-only - etx4 (alternative to step 4.1)
For ext4, in order to put the root in read-only, inside ```/etc/fstab``` change the 4th column of the line related to ```/``` in order to specify only "ro".
At the end, the file should look like this:

![fstab ro rooot](/assets/images/dmverity/8%20-%20fstab%20-%20ro%20root.png){: .center-image}

Reboot the system. Make sure everything is working trying to create a directory in /. The operations should fail:

![mmkdir output](/assets/images/dmverity/9%20-%20mkdir%20output.png){: .center-image}

# 5 - Activation of dm-verity
At this point everything is ready to enable dm-verity. This operation can be done only if the root partition is not mounted, otherwise it will fail. Because of this it is important to boot from a live system.

Since dm-verity need to store this hash-tree somewhere, the most simple thing is to create another hard-disk where to store these information. Making an hard-disk of 1GB is enough for this purpose. This tutorial will assume that this disk is ```/dev/sdc```.

After the new hard disk is created and connected to the system, proceed to partition it as shown before, running:

```bash
fdisk /dev/sdc
# Press, in order, n, p, 1, (enter), (enter), w
```

There are 2 possible approaches to enable dm-verity:

1. The first is with the use of dmsetup, that is a tool that is used to create a mapper device. Since a mapper can be used for different purposes, this tool is not specific for dm-verity and must be invoked in a certain way in order to enable the usage of dm-verity.
2. The second is with the use of veritysetup, that is a more high-level tool that can configure a device-mapper device that is specific for dm-verity. Under the hood is doing the same thing of dmsetup but it's easier to use since it's made for dmverity.
This tutorial will use the second approach.

Mount a writable partition as a general purpose storage, for example the ```/home``` partition (it will be needed later):

```bash
mkdir storage
mount /dev/sda8 ./storage
```
Create the hash tree and save the root hash into the storage:

```bash
cd ./storage
veritysetup format /dev/sda1 /dev/sdc1 > output_veritysetup
```

The content of output should be something like this:

![veritysetup format output](/assets/images/dmverity/10%20-%20veritysetup%20format%20-%20output.png){: .center-image}

To simplify subsequent steps, create a ```root_hash``` file and copy into that only the real root hash (remove other output from ```veritysetup```):

![root hash](/assets/images/dmverity/11%20-%20root_hash.png){: .center-image}

At this point it is possible to test that everything is working properly by creating the device-mapper device and test it:
```bash
veritysetup create vroot /dev/sda1 /dev/sdc1 $(cat root_hash)
# Ensure the system is integer
veritysetup verify /dev/sda1 /dev/sdc1 $(cat root_hash) # It will take a while, if no output is produced it means everything is OK
# Mount the partition with dm-verity enabled
mkdir verity-root
mount /dev/mapper/vroot ./verity-root
```

Output will look like this:

![mount mapper device](/assets/images/dmverity/12%20-%20mount%20mapper%20device.png){: .center-image}

At this point, verity-root contains the mounted root file-system with dm-verity enabled. Every change to the file-system will corrupt dm-verity hash-tree and make the system unusable.

# 6 - Make it bootable
At this point, the only part that is left is to tell the kernel to create/use the device mapper. In order to do this, it is possible to use the kernel argument "dm-mod.create" anche change the root argument.

dm-mod.create accept as parameter the mapper table that we can obtain in an easy way with the output of the command dmsetup table:

![dmsetup table](/assets/images/dmverity/13%20-%20dmsetup%20table.png){: .center-image}

What it is needed to specify to dm-mod.create is an argument that takes the shape of ```<name>,<uuid>,<minor>,<flags>,<output of dmsetup table>```:

- name: name of the mapping that udev will assign after boot so that the device mapper could be found ```/dev/mapper/<name>```
- uuid: optional uuid to assign to the device mapper after creation
- minor: minor of the dm device to make it possible to find it in ```/dev/dm-<minor>```
- flags: flags, like read-only
- output of dmsetup table: literally the output of dmsetup table without the first part that contains the name of the mapping followed by a colon

After putting together these information, we can put the argument inside ```/boot/grub/grub.cfg```. The final line related to the kernel loading will look like this:

![grub cfg](/assets/images/dmverity/14%20-%20grub%20cfg.png){: .center-image}

Note that also the root argument has been changed, to map what will be the new device: ```/dev/dm-<minor>```. Pay attention when updating grub as the modification ```/boot/grub/grub.cfg``` will be lost. In order to make a permanent modification, edit the default grub config file inside ```/etc```.

At this point the system can be rebooted, after reboot the output of ```mount | grep root```  and ```dmsetup``` table should look like this:

![mount dmsetup](/assets/images/dmverity/15%20-%20mount%20-%20dmsetup.png){: .center-image}

# References
1. [Kernel documentation - Device Mapper](https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/index.html)
1. [Cryptsetup documentation - dmverity](https://gitlab.com/cryptsetup/cryptsetup/-/wikis/DMVerity)
1. [Introduction on dm-verity on Android](https://www.kynetics.com/docs/2018/introduction-to-dm-verity-on-android/)
1. [RedHat documentation - LVM - Device mapper](https://access.redhat.com/documentation/it-it/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/device_mapper)
1. [Gentoo documentation - Device mapper](https://wiki.gentoo.org/wiki/Device-mapper)
1. [squashfs as read-only filesystem](https://magazine.odroid.com/article/using-squashfs-as-a-read-only-root-file-system/)
1. [Android documentation - Android verified boot](https://source.android.com/security/verifiedboot/avb)
1. [Bootlin - Verified boot](https://bootlin.com/pub/conferences/2018/elc/josserand-schulz-secure-boot/josserand-schulz-secure-boot.pdf#4)
1. [Integrity lifecycle](https://docs.openstack.org/security-guide/management/integrity-life-cycle.html)
