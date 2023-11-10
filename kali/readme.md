# Kali utilities

Simple tools that were tested in Kali.

# Kali DHCP Server

Script to launch a DHCP server on Kali. Optionally, you can
save traffic to a PCAP file for packet inspection later. You 
probably don't want to use this on as a full-time DHCP server,
though.

Requirements:

- Two physical network interfaces
- dnsmasq
- iptables
- tshark (optional)
- nohup (optional)
