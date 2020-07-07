#!/bin/bash

clear

echo ''
echo ''
echo '=========================='
echo '=====脚本来自：sm.link====='
echo '=========================='
echo ''
echo ''

sleep 2s

yum -y install curl

curl https://boot.netboot.xyz/ipxe/netboot.xyz.lkrn -o /boot/generic-ipxe.lkrn

echo "
#!ipxe
#/boot/netboot.xyz-initrd
imgfree
dhcp
set dns 8.8.8.8
ifopen net0
chain --autofree https://boot.netboot.xyz
" > /boot/netboot.xyz-initrd

echo "
exec tail -n +3 $0
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.
menuentry 'netboot.xyz' {
set root='hd0,msdos1'
linux16 /boot/generic-ipxe.lkrn
initrd16 /boot/netboot.xyz-initrd
}
" > /etc/grub.d/40_custom

echo "GRUB_TIMEOUT=60" >> /etc/default/grub

sort -n /etc/default/grub | uniq

grub2-mkconfig -o /etc/grub2.cfg

echo ''
echo ''
echo ''
echo ''
echo '配置已完成，请连接VNC后输入重启命令：reboot'
echo ''
echo ''
