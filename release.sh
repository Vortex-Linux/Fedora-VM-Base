#!/bin/bash 

echo "Shutting down the Fedora VM..." 

echo y | ship --vm shutdown fedora-vm-base 

echo "Compressing the Fedora VM disk image..."

ship --vm compress fedora-vm-base 

echo "Copying the Fedora VM disk image to generate the release package for 'fedora-vm-base'..."

DISK_IMAGE=$(sudo virsh domblklist fedora-vm-base | grep .qcow2 | awk '{print $2}')

cp "$DISK_IMAGE" output/fedora.qcow2

echo "Splitting the copied disk image into two parts..."

split -b $(( $(stat -c%s "output/fedora.qcow2") / 2 )) -d -a 3 "output/fedora.qcow2" "output/fedora.qcow2."

echo "The release package for 'fedora-vm-base' has been generated and split successfully!"

