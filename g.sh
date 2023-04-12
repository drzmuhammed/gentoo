#!/bin/bash
wget https://cdn.githubraw.com/drzmuhammed/gentoo/main/g1.sh
chmod +x g1.sh
./g1.sh
cd /mnt/gentoo 
chroot /mnt/gentoo /bin/bash 
source /etc/profile 
export PS1="(chroot) ${PS1}" 
chmod +x /mnt/gentoo/g2.sh
./mnt/gentoo/g2.sh  
env-update  source /etc/profile  export PS1="(chroot) ${PS1}" 
chmod +x /mnt/gentoo/g3.sh
./mnt/gentoo/g3.sh
cd /usr/src/linux 
make menuconfig
chmod +x /mnt/gentoo/g4.sh
./mnt/gentoo/g2.sh
cd  
umount -l /mnt/gentoo/dev{/shm,/pts,} 
umount -R /mnt/gentoo 
reboot
