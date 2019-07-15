#!/bin/bash
if [ $# -ne 0  ];then
  interface="$1"
  nic_pci_id=$(udevadm info -a -p /sys/class/net/"$interface"| awk -v pat="devices.*$interface" -F/ '$0~pat {print $4}' | awk -F: '{print $2":"$3}')
  echo "$nic_pci_id"
else
  echo "Usage $0 <network interface name>"
  echo "$0 eth0(eno1)"
fi
