#!/bin/sh

set -e

echo "Warning: ONLY run this script via the nc backdoor, not via SSH!"
echo "Removing OpenCentauri remnants..."

echo "Killing sshd process..."
pid=$(pgrep -f "/opt/sbin/sshd")
[ -n "$pid" ] && kill "$pid"

echo "SSH process killed, killing mount_usb_daemo process..."
pid=$(pgrep -f "mount_usb_daemo")
[ -n "$pid" ] && kill "$pid"

echo "Success: waiting 10 seconds!"
sleep 10

echo "Checking for processes still using /opt using lsof:"
# Capture the multi-line output of lsof into a variable and print it
LSOF_OPT=$(lsof /opt || true) # The '|| true' prevents set -e from stopping script if lsof finds nothing/fails
echo "$LSOF_OPT" 
echo "Lsof check complete, unmounting /opt..."
umount -l /opt

echo "Checking for processes still using /root using lsof:"
# Capture the multi-line output of lsof into a variable and print it
LSOF_ROOT=$(lsof /opt || true) # The '|| true' prevents set -e from stopping script if lsof finds nothing/fails
echo "$LSOF_ROOT" 
echo "Lsof check complete, unmounting /root..."
umount /root
echo "Unmounting success!"

rm -rf /user-resource/OpenCentauri
cp /etc/swupdate_public_cc.pem /etc/swupdate_public.pem
md5sum /etc/swupdate_public.pem
echo "Done. Install an official update to restore your system."
