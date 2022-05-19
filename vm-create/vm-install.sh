#!/usr/bin/env bash

inventory_hostname=vn-d
pool_name=cem-pool
image_src=$HOME/images/CentOS-7-x86_64-GenericCloud-2009.qcow2

vcpus=8
ramsize=49512
disksize=300G
network1=bridge=breno1,mac=02:00:0a:55:c0:2b

destroy_vm () {
	virsh destroy $inventory_hostname
	virsh undefine $inventory_hostname --remove-all-storage
}

create_pool () {
	sudo mkdir /var/lib/libvirt/cem-pool
	sudo chown $USER: /var/lib/libvirt/cem-pool
	virsh pool-define-as cem-pool dir - - - - /var/lib/libvirt/cem-pool
	virsh pool-start cem-pool
	virsh pool-autostart cem-pool
}

create_vm () {
    rm -f $inventory_hostname.iso
    genisoimage -input-charset  utf-8 -o $inventory_hostname.iso -volid cidata -joliet -rock user-data meta-data network-config

    virsh vol-create-as $pool_name $inventory_hostname.iso 1g --format raw
    virsh vol-upload $inventory_hostname.iso $inventory_hostname.iso --pool $pool_name


    virsh vol-create-as $pool_name $inventory_hostname $disksize --format qcow2
    virsh vol-upload $inventory_hostname $image_src --pool $pool_name
    virsh vol-resize $inventory_hostname $disksize --pool $pool_name


    virt-install \
    --virt-type kvm \
    --autostart \
    --name $inventory_hostname \
    --vcpu $vcpus \
    --ram $ramsize  \
    --disk vol=$pool_name/$inventory_hostname,format=qcow2 \
    --network $network1 \
    --graphics vnc,listen=0.0.0.0 \
    --noautoconsole \
    --os-type=linux \
    --os-variant=centos7.0 \
    --import \
    --cpu host \
    --disk vol=$pool_name/$inventory_hostname.iso,device=cdrom
}

case "$1" in
	"destroy")
		destroy_vm "@"; exit;;
	*)
		create_vm ; exit ;;
esac

