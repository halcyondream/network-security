# Suricata

Notes for setting up a simple Suricata instance.

Install:

  apt install suricata

Uncomment the correct lines in the stock YAML file, notably:

- The syslog section for alerts (and optionally process info in the EVE
  module)

- Set the network interface to whatever is facing the LAN (*not* the 
  WAN)

Put custom rules in the */etc/suricata/rules* folder, with the `.rules`
suffix.

To restart the whole process and update rules:

  systemctl restart suricata

Use the same port rule and *rsyslog.d* config from the Snort section.
