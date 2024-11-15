#!/bin/bash

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
XML_FILE="/tmp/fedora-vm-base.xml"

LATEST_IMAGE=$(lynx -dump -listonly -nonumbers https://fedoraproject.org/server/download | grep x86_64 | grep iso | grep netinst)

echo y | ship --vm delete fedora-vm-base 

echo n | ship --vm create fedora-vm-base --source "$LATEST_IMAGE"

sed -i '/<\/devices>/i \
  <console type="pty">\
    <target type="virtio"/>\
  </console>' "$XML_FILE"

virsh -c qemu:///system undefine fedora-vm-base
virsh -c qemu:///system define "$XML_FILE"

echo "Building of VM Complete.Starting might take a while as it might take a bit of type for the vm to boot up and be ready for usage."
ship --vm start fedora-vm-base 

