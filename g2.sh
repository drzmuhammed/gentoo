#!/bin/bash
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
