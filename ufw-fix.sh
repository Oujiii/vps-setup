#!/bin/bash

# Change iptables on Debian Buster to use iptables-legacy. More here: https://wiki.debian.org/iptables and here https://askubuntu.com/questions/1197640/ufw-init-errors-out-with-bad-argument-drop
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

echo "Now using iptables legacy"
