# Suricata

Notes for setting up a simple Suricata instance.

Install:

    apt install suricata

On Debian systems, the configuration files are in _/etc/suricata_ and
_/etc/suricata/rules_. Make the following changes:

- Uncomment syslog section for alerts (and optionally process info in
  module)

- Set the network interface to whatever is facing the LAN (*not* the 
  WAN)

Put custom rules in the */etc/suricata/rules* folder, with the `.rules`
suffix. A simple example in _/etc/suricata/rules/custom.rules_:

    alert ip $HOST_NET [!9000] -> any [!80,!443,!9000] (msg:"Local machine trying to access a non-HTTP/S port.";sid:112233445;)

could help identify suspicious traffic on a LAN where hosts are
expected to access only HTTP/S traffic. (Graylog's default webserver
is on port 9000 and is optional if you're not using that port.)

To restart the whole process and update rules:

    systemctl restart suricata

Use the same port rule and *rsyslog.d* config from the Snort section.
