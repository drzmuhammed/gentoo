#!/bin/bash
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