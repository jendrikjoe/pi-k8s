#!/bin/bash
set -e
# unzip $1
IMAGE_FILE_NAME=${1/zip/img}
sudo dd bs=32M if=$IMAGE_FILE_NAME of=$2
sync
MOUNT_DIR=/media/$USER/boot
sudo mkdir $MOUNT_DIR
sudo mount "${2}p1" $MOUNT_DIR
# Enable ssh
sudo touch "${MOUNT_DIR}/ssh"
# Copy wpa supplicant
sudo cp $3 $MOUNT_DIR/wpa_supplicant.conf
FS_MOUNT_DIR=/media/$USER/rootfs
sudo mkdir $FS_MOUNT_DIR
sudo mount "${2}p2" $FS_MOUNT_DIR

# Disable set password for pi user
sudo sed -i "s/pi:x:1000/pi::1000/" $FS_MOUNT_DIR/etc/passwd
# Diable ssh pw login
sudo sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/" $FS_MOUNT_DIR/etc/ssh/sshd_config
sudo sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" $FS_MOUNT_DIR/etc/ssh/sshd_config
sudo sed -i "s;#AuthorizedKeysFile*;AuthorizedKeysFile /etc/ssh/%u/authorized_keys;" $FS_MOUNT_DIR/etc/ssh/sshd_config
sudo mkdir $FS_MOUNT_DIR/etc/ssh/pi
curl https://github.com/jendrikjoe.keys >> keys 
curl https://github.com/juliusv.keys >> keys
sudo cp keys $FS_MOUNT_DIR/etc/ssh/pi/authorized_keys
rm keys
echo "$4" > hostname
sudo cp hostname $FS_MOUNT_DIR/etc/hostname
rm hostname
sudo chown 1000:1000 $FS_MOUNT_DIR/etc/ssh/pi/authorized_keys
sync

sudo umount $MOUNT_DIR
sudo rm -r $MOUNT_DIR

sudo umount $FS_MOUNT_DIR
sudo rm -r $FS_MOUNT_DIR

