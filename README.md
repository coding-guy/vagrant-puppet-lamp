Vagrant/Puppet LAMP
==================

This will create a basic VM for local development, without crapping up your daily driver OS.

This is the spiritual successor to my previous article,
["Setting Up a VM, Step by Step"](https://jtreminio.com/2012/07/setting-up-a-debian-vm-step-by-step).

Vagrantfile
------------------
The base box is the official Ubuntu Precise64 from vagrantup.com.

The IP address is 192.168.123.101

Files are shared using NFS.

Debian/Ubuntu users, install nfsd by `$ sudo apt-get install nfs-kernel-server`

Mac OS X has this preinstalled.

If you are on Windows, remove `, :nfs => true` from the `config.vm.synced_folder` line.

All OS should change the two directories to match their setup. `/var/www` is the default, so you should consider
leaving it as is. The `../../www` is what you want to change to reflect your host OS file locations.

Puppet Manifest
-------------------

I'm mostly using [example42](http://www.example42.com) modules because I have found them to be the easiest to use.

I have create 3 sample vhost entries. Delete/edit to your hearts' desire.

The latest PHP 5.4.x is installed. If you want PHP 5.3, remove the following:

    apt::ppa { 'ppa:ondrej/php5' : }

and

        require => Apt::Ppa['ppa:ondrej/php5'],

Several PHP modules are installed. Add/remove as you wish. I have also included Xdebug. You should really be using
Xdebug. Do you want to know more?
[Learn you some reasons: Xdebug and You: Why You Should be Using a Real Debugger](https://jtreminio.com/2012/07/xdebug-and-you-why-you-should-be-using-a-real-debugger)

Boom
-----------
This has been a labor of love and extreme frustration. I floundered for ~48 hours with Vagrant which has horrible
documentation for v2 as to the possible variables, and Puppet which simply laughed at me while I tried to get it
to fucking install PHP before trying to install Xdebug god damnit!

It is still in a beta state, but I have tested it *several* times (read: many hundreds of VMs were killed in the
making of this repo) and have found it to work very well.

If you are a Puppet master please consider contributing!
