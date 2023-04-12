#!/bin/bash
cd /mnt/gentoo 
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
exit 
