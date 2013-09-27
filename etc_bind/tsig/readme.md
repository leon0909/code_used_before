# you can create a simple 16 byte tsig key to use 
# just change in this dir and call:
#
dnssec-keygen -a HMAC-MD5 -b 16 -n HOST example.com.

# look how the resulting from it files are deployed in the etc_bind and etc_dhcp,
# look into the dhcpd.conf and the zone files in these dirs.
