#!/bin/bash

# Define the DHCP properties.
DHCP_IFACE=eth1
NET_IFACE=eth0
DNSMASQ_CONF=/etc/dnsmasq.d/start-dhcpd
SUBNET_MASK=255.255.255.0
GATEWAY_IP=10.0.0.1
START_IP=10.0.0.20
END_IP=10.0.0.30
DNS_1=8.8.8.8
DNS_2=1.1.1.1
USER=kali
PCAP_FILE=snoop.pcap

function kill_server() {
  # Revert the major network configurations.
  rm "$DNSMASQ_CONF"
  ifconfig $DHCP_IFACE 0.0.0.0
  ifconfig $DHCP_IFACE down
  sysctl net.ipv4.ip_forward=0
  iptables -t nat -D POSTROUTING -o $NET_IFACE -j MASQUERADE
  systemctl stop dnsmasq
  systemctl restart networking
  systemctl start NetworkManager.service
  iptables -D INPUT -i eth0 -j DROP
}

function start_server() {
  # Create a fresh copy of the desired dnsmasq config.
  echo "
    interface=$DHCP_IFACE
    except-interface=$NET_IFACE
    dhcp-range=$START_IP,$END_IP,$SUBNET_MASK,24h
    server=$DNS_1
    server=$DNS_2
    log-dhcp
    dhcp-authoritative
    bind-interfaces
  " > "$DNSMASQ_CONF" && \    
  # Set service states.
  systemctl stop NetworkManager.service && \
  systemctl start dnsmasq && \
  systemctl restart networking && \
  # Configure firewall and interfaces.
  iptables -A INPUT -i eth0 -j DROP
  ifconfig eth0 up
  ifconfig eth1 up
  ifconfig $DHCP_IFACE $GATEWAY_IP && \
  sysctl net.ipv4.ip_forward=1 && \
  iptables -t nat -A POSTROUTING -o $NET_IFACE -j MASQUERADE && \
  return 0 || return -1
}

# Complain if dnsmasq isn't installed.
if [ ! "$(which dnsmasq)" ]; then
  echo '[!] dnsmasq not found.'
  echo '[+] Run `apt install dnsmasq` then rerun this script.'
  exit 1
fi

# Clean any stale DHCP settings.
kill_server
echo "[+] DHCP server successfully stopped."

if [[ "$1" == "kill" ]]; then
  exit 0
fi

# Start the server. If something fails, revert changes and exit.
start_server \
|| ( \
  echo "[!] Error occurred. Reverting..."
  kill_server
  exit 1
)

# Print diagnostic info.
ifconfig $DHCP_IFACE
iptables -t nat -L POSTROUTING
echo "dnsmasq: $(systemctl is-active dnsmasq.service)"

# If desired, capture all network traffic.
if [[ "$1" == "snoop" ]]; then
  nohup sudo -u $USER \
    tshark -i $NET_IFACE -w $PCAP_FILE -q &
fi

echo "[+] DHCP server successfully started."
