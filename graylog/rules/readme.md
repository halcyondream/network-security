# Graylog rules

Simple rules to inspect packets. I configured these to run in two stages:

1. Extract fields from packets/sources.
2. Sanitize fields that didn't exist during extraction.

The Snort3 extractor works for Suricata in IDS mode.
