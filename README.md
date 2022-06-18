# DHCP and PXE boot server in a LXD Container with macvlan

## 1. Launch container image with macvlan

	lxc launch ubuntu:20.04 dhcp
	lxc profile copy default lanprofile
	lxc profile edit lanprofile 

### Edit 'lanprofile' accordingly ...

	config: {}
	description: local LAN profile
	devices:
	  eth0:
	    nictype: macvlan
	    parent: eno1
	    type: nic
	  root:
	    path: /
	    pool: lxd
	    type: disk
	name: lanprofile

### Apply profile ...

	lxc profile assign dhcp lanprofile
	lxc restart dhcp

### Set macaddress on container interface:

Run program bin/newmac.sh and add MAC-address to container:

	lxc config set dhcp volatile.eth0.hwaddr A1:B2:C3:D4:E5:F6
	lxc restart dhcp

### Set static ipv4 address on your local network:

	lxc config device set dhcp eth0 ipv4.address 192.168.0.X
	lxc restart dhcp

## 2. Update system

	sudo apt-get update

## 3. Install dnsmasq

	sudo apt-get install dnsmasq
	sudo systemctl stop dnsmasq

## 4. Create directories for dnsmasq and pxeboot-files

	mkdir -p /opt/dnsmasq/dhcp
	mkdir -p /opt/dnsmasq/tftp/pxeboot
	chown ubuntu:ubuntu -R /opt/dnsmasq/dhcp
	chown ubuntu:ubuntu -R /opt/dnsmasq/tftp

## 5. Copy configuration files

Edit etc/dnsmasq.conf according to your network and liking ...

	lxc file push etc/dnsmasq.conf LXD-server:dhcp/etc/dnsmasq.conf --gid 0 --uid 0 --mode "644"
	lxc file push etc/logrotate.d/dhcp LXD-server:dhcp/etc/logrotate.d/dhcp --gid 0 --uid 0 --mode "644"

## 6. Copy tftp data and configure

	lxc file push data/tftp_base.tar.gz LXD-server:dhcp/opt/dnsmasq/
	lxc exec LXD-server:dhcp -- bash
	cd /opt/dnsmasq
	tar xvf tftp_20201114.tar.gz 
	chown ubuntu:ubuntu -R tftp

### Edit bootloader menu 

	nano /opt/dnsmasq/tftp/pxeboot/cascade-bootloader/installer/boot-screens/menu.cfg

Change line with: menu title Cascade 1733 Boot Options (dhcp)

## 7. Start dnsmasq server

	sudo systemctl start dnsmasq

### EOF
