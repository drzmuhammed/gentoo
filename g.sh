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
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | chroot /mnt/gentoo /bin/bash 
  source /etc/profile 
  export PS1="(chroot) ${PS1}" 
  mount /dev/vda1 /boot 
  emerge-webrsync 
  emerge --sync 
  eselect profile set 1 
  emerge --ask --verbose --update --deep --newuse @world 
  emerge --ask app-portage/cpuid2cpuflags 
  echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags 
  echo "Asia/Kolkata" > /etc/timezone 
  emerge --config sys-libs/timezone-data 
  echo "en_US ISO-8859-1" >> /etc/locale.gen 
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen 
  locale-gen 
  echo "LANG="en_US.UTF-8"" >> /etc/env.d/02locale 
  echo "LC_COLLATE="C.UTF-8"" >> /etc/env.d/02locale 
  env-update  source /etc/profile  export PS1="(chroot) ${PS1}" 
  echo "sys-kernel/linux-firmware linux-fw-redistributable" >> /etc/portage/package.license 
  echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" >> /etc/portage/package.license 
  echo "sys-firmware/intel-microcode @BINARY-REDISTRIBUTABLE" >> /etc/portage/package.license 
  echo "sys-firmware/intel-microcode linux-fw-redistributable" >> /etc/portage/package.license 
  emerge --ask sys-kernel/linux-firmware 
  emerge --ask sys-firmware/intel-microcode 
  mkdir --parent /etc/dracut.conf.d 
  echo "early_microcode="yes"" >> /etc/dracut.conf.d/microcode.conf 
  emerge --ask sys-kernel/gentoo-sources 
  emerge --ask sys-apps/pciutils 
  cd /usr/src/linux 
  make menuconfig 
  make && make modules_install 
  make install 
  emerge --ask sys-kernel/dracut 
  dracut --kver=6.1.9-gentoo 
  echo "/dev/vda1 /boot        vfat    defaults,noatime     0 2" >> /etc/fstab 
  echo "/dev/vda3 /            ext4    noatime              0 1" >> /etc/fstab 
  echo "drzpc" >> /etc/hostname 
  emerge --ask net-misc/dhcpcd 
  rc-update add dhcpcd default 
  rc-service dhcpcd start 
  sed -i '/127.0.0.1    localhost/c\127.0.0.1   drzpc.homenetwork   drzpc   localhost' /etc/hosts 
  passwd 
  emerge --ask app-admin/sysklogd 
  rc-update add sysklogd default 
  emerge --ask sys-process/cronie 
  rc-update add cronie default 
  emerge --ask sys-apps/mlocate 
  emerge --ask net-misc/chrony 
  rc-update add chronyd default 
  echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf 
  emerge --ask sys-boot/grub 
  grub-install --target=x86_64-efi --efi-directory=/boot --removable 
  grub-mkconfig -o /boot/grub/grub.cfg
EOF 
exit 
cd  
umount -l /mnt/gentoo/dev{/shm,/pts,} 
umount -R /mnt/gentoo 
reboot
