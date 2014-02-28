Setting-up LinuX Containers and deploying with Chef
==========

In this short article, I'll show you, how to set-up LinuX Containers on your server and deploy 
these containers using [Librarian Chef]: https://github.com/applicationsonline/librarian-chef and
[Knife Solo]: https://github.com/matschaffer/knife-solo .

For testing I used machine with Debian 7.0 Wheezy. Run all commands with root privileges

LinuX Containers (LXC)
=========

First, let's install lxc:

    apt-get install lxc

Now we need to check if out kernel configuration is good enough to run LXC:

    lxc-checkconfig 

If there's any problem, you should fix it. Otherwise, some functions may not work and cause
problems on production server. Default Debian 7 wheezy kernel passes all tests.

Allright, now let's install all remaining packages, that we will use during this section.

    apt-get install bridge-utils libvirt-bin debootstrap dnsmasq-base

Now, append this line to **/etc/fstab**

    cgroup  /sys/fs/cgroup  cgroup  defaults  0   0

And now mount cgroup

    mount /sys/fs/cgroup

Now. You're ready to set up a container.

Setting up a libvirt virtual bridge
---------

We need some way to connect all devices together and let them access the Internet. To do so, we'll
create a network bridge using libvirt.

By default all containers will use DHCP to automaticaly set-up network interfaces. It's quite pain
in the ass, while working with Chef, but it is your choice if you want to have static IP addressing.

//@TODO Turning-off dnsmasq


Setting up an example LXC container
------------

Firstly - create a Debian container. 

    lxc-create -n example -t debian

**Important thing!** You need to be careful now. Don't launch container before you have configured
network device on container. If you don't do that, you may lost network connection with your 
machine

To do that, open-up config file (e.g. /var/lib/lxc/example/config ) and append these lines:

    lxc.network.type = veth                
    lxc.network.flags = up                 
    lxc.network.link = virbr0              
    lxc.network.ipv4 = 192.168.122.10/24   

Controlling the container
----------

To start container, issue the command. 'd' flag makes it run in background.
    
    lxc-start -n example -d

To stop container we should use:

    lxc-halt -n example

To stop container in less subtle way, we use:

    lxc-stop -n example

We can also list all existing containers:

    lxc-ls

