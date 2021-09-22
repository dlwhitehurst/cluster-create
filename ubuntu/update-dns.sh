#!/bin/bash
# assures that a DNS server exists for the new machine
sed -i -e 's/#DNS=/DNS=8.8.8.8/' /etc/systemd/resolved.conf
service systemd-resolved restart
