title: Vpnc and Split Tunnel

author: Johannes Markert

published: September 2016

synopsis:
    How to setup a vpn tunnel to a CISCO(tm)-type vpn connection via the vpn tool
    and configure the ip routing in a way that only the packets destined for the
    vpn network are routed there. Thus, normal packets, like internet, are just
    handled like normal. I will show this by a specific example on connecting to
    the UKlan network of the University of Cologne.

---

Disclaimer
----------

Following HowTo is based on a [tutorial][tut] written by Antonio Borneo posted on
the mailinglist "vpnc-devel".

As disclaimed there, I a want to raise possible security issues, too. By
establishing a route from your local network over a vpn, every user on your
machine has access to the other coorporate network, as well. Be aware of this!

Install vpnc
------------

	pacman -S vpnc

Save following config to: "/etc/vpnc/uklan.conf"
-------------------------------------------------

    Script	/etc/vpnc/vpnc-script-uklan-split
    IPSec	gateway vpngate.uni-koeln.de 
    IPSec	ID uklan-full
    IPSec	secret uklan
    Xauth	username <your username>

The config file as well as further instructions are publicly available on
[UKlan][uklan].

Write the connection script file mentionend in above config file
-----------------------------------------------------------------

    #!/bin/sh
    
    # Initialize empty split tunnel list
    export CISCO_SPLIT_INC=0
    
    # Delete DNS info provided by VPN server to use internet DNS
    # Comment following line to use DNS beyond VPN tunnel
    unset INTERNAL_IP4_DNS
    
    source /etc/vpnc/vpnc-script

Do not forget to make '/etc/vpnc/vpnc-script-uklan-split' executable. The script
disables more or less the tampering of the local routing table by 'vpnc'. We
will configure the routing manually later on.

Start the vpn demon
--------------------

    sudo vpnc uklan.conf

vpnc will interactively asks you for a password and if everthings is working
allright greets with a banner of the vpn network.

Configure new route
--------------------

    sudo ip route add 134.95.0.0/16 dev tun0

The address space 134.95.xxx.xxx belongs to the University of Cologne which is
our network we wanted to connect via vpn in the first place.

Conclusion
----------

Finally, one should be able to reach the private hosts of UKlan and browse the
internet as usual.

Further ideas
-------------

### Add a dns nameserver of the UKlan network (not bullet-proof yet!)

    echo nameserver noc2.rrz.uni-koeln.de | sudo tee -a /etc/resolv.conf

On most systems one has to wait for a while till the nameserver gets propagated
through the ip stack.


[tut]: http://lists.unix-ag.uni-kl.de/pipermail/vpnc-devel/2009-February/002990.html
[uklan]: https://rrzk.uni-koeln.de/linux-vpnc.html?&L=1
