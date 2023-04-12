#!/bin/bash
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
exit 