#!/bin/sh

MAC_ADDRESS=$(cat /sys/class/net/eth0/address)
JSON_MAC_ADDRESS="{\"mac_address\": \"$MAC_ADDRESS\"}"
echo "$JSON_MAC_ADDRESS" > /var/www/html/index.html

cd /var/www/html/

busybox httpd -f -p 8080
netstat -tuln
