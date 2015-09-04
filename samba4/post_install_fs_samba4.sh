#!/bin/bash

domain_server=$(net ads info | grep "LDAP server:" | cut -d: -f2)
domain_name=$(net ads info | grep "LDAP server name:" | cut -d: -f2 | cut -d. -f2-5)
local_ip=$(ip -4 a | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -d"/" -f1)

# Disable SELINUX
# Here there is a TODO, you can map what you need to set on Selinux, or disable it:
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Set samba classic mode
sed -i 's/SAMBA_START_MODE="none"/SAMBA_START_MODE="classic"/g' /etc/default/sernet-samba

# Hide domain name
authconfig --enablewinbindusedefaultdomain --update

# Setup services
chkconfig sernet-samba-nmbd on
chkconfig sernet-samba-smbd on
chkconfig sernet-samba-winbindd on

# Restart services
systemctl restart sernet-samba-smbd
systemctl restart sernet-samba-nmbd
systemctl restart sernet-samba-winbindd

# See domain info
echo -e "\nPress <enter> to show domain info."
read anyk
net ads info

echo -e "\nPress <enter> to show users."
read anyk
wbinfo -u

echo -e "\nAdding DNS entry...\n"
samba-tool dns add $domain_server $domain_name $(hostname -s) A $local_ip -Uadministrator

echo -e "\nGranting ACL permissions...\n"
net rpc rights grant 'domain admins' SeDiskOperatorPrivilege -U'administrator' -I $(hostname)
