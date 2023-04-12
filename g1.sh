#!/bin/bash 
ping -c 3 www.gentoo.org 
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/vda
  g # clear the in memory partition table
  n # new partition
  1 # partition number 1
    # default - start at beginning of disk 
  +256M # 256 MB boot parttion
  t
  1
  n # new partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF
mkfs.vfat -F 32 /dev/vda1 
mkfs.ext4 /dev/vda2 
mount /dev/vda2 /mnt/gentoo 
ntpd -q -g 
cd /mnt/gentoo 
wget https://github.com/drzmuhammed/gentoo/blob/main/g2.sh
wget https://github.com/drzmuhammed/gentoo/blob/main/g3.sh
wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20230409T163155Z/stage3-amd64-openrc-20230409T163155Z.tar.xz 
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner 
sed -i '/COMMON_FLAGS="-O2 -pipe"/c\COMMON_FLAGS="-mtune=skylake -O2 -pipe"' /mnt/gentoo/etc/portage/make.conf 
echo "MAKEOPTS="-j1"" >> /mnt/gentoo/etc/portage/make.conf 
echo "ACCEPT_LICENSE="-* @FREE"" >> /mnt/gentoo/etc/portage/make.conf 
mkdir --parents /mnt/gentoo/etc/portage/repos.conf 
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf 
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/ 
mount --types proc /proc /mnt/gentoo/proc 
mount --rbind /sys /mnt/gentoo/sys 
mount --make-rslave /mnt/gentoo/sys 
mount --rbind /dev /mnt/gentoo/dev 
mount --make-rslave /mnt/gentoo/dev 
mount --bind /run /mnt/gentoo/run 
mount --make-slave /mnt/gentoo/run 
chroot /mnt/gentoo /bin/bash   
