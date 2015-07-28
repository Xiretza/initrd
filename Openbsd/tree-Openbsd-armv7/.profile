#!/bin/sh


set -x


echo "[+] Setting up environment"
export VNAME=$(sysctl -n kern.osrelease)
export VERSION="${VNAME%.*}${VNAME#*.}"
export ARCH=$(sysctl -n hw.machine)
export PATH=/sbin:/bin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/
umask 022
set -o emacs


echo "[+] Remounting ramdisk read-write"
mount -uw /


echo "[+] Populating /dev"
mknod /dev/nbd0a b 21 0
mknod /dev/nbd0b b 21 1
mknod /dev/nbd0c b 21 2
mknod /dev/nbd0d b 21 3
mknod /dev/nbd0e b 21 4
mknod /dev/nbd0f b 21 5
mknod /dev/nbd0g b 21 6
mknod /dev/nbd0h b 21 7
mknod /dev/nbd0i b 21 8
mknod /dev/nbd0j b 21 9
mknod /dev/nbd0k b 21 10
mknod /dev/nbd0l b 21 11
mknod /dev/nbd0m b 21 12
mknod /dev/nbd0n b 21 13
mknod /dev/nbd0o b 21 14
mknod /dev/nbd0p b 21 15
mknod /dev/rnbd0a c 21 0
mknod /dev/rnbd0b c 21 1
mknod /dev/rnbd0c c 21 2
mknod /dev/rnbd0d c 21 3
mknod /dev/rnbd0e c 21 4
mknod /dev/rnbd0f c 21 5
mknod /dev/rnbd0g c 21 6
mknod /dev/rnbd0h c 21 7
mknod /dev/rnbd0i c 21 8
mknod /dev/rnbd0j c 21 9
mknod /dev/rnbd0k c 21 10
mknod /dev/rnbd0l c 21 11
mknod /dev/rnbd0m c 21 12
mknod /dev/rnbd0n c 21 13
mknod /dev/rnbd0o c 21 14
mknod /dev/rnbd0p c 21 15


echo "[+] Performing DHCP request"
dhclient mvneta0


echo "[+] Attaching nbd0"
export_uri=$(oc-metadata VOLUMES_0_EXPORT_URI)
nbd_host=$(echo $export_uri | sed -n 's#nbd://\(.*\):.*$#\1#p')
nbd_port=$(echo $export_uri | sed -n 's#nbd://.*:\(.*\)$#\1#p')
xnbd-client $nbd_host $nbd_port /dev/nbd0c


echo "[+] Running fsck on nbd0"
fsck /dev/nbd0a


echo "[+] Mounting nbd0"
mount /dev/nbd0a /mnt


echo "[+] pivot_root in /mnt"
mkdir -p /mnt/old
pivot_root /mnt /mnt/old


echo "[-] Droping a debug shell"
exec /bin/sh
