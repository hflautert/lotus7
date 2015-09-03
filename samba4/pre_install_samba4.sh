#!/bin/bash

# Add repo
wget -O /etc/yum.repos.d/sernet-samba.repo https://sernet-samba-public:Noo1oxe4zo@download.sernet.de/packages/samba/4.2/rhel/7/sernet-samba-4.2.repo

# Set repo credentials
sed -i 's/USERNAME:ACCESSKEY/sernet-samba-public:Noo1oxe4zo/g' /etc/yum.repos.d/sernet-samba.repo

# Installing packages
yum -y install sernet-samba sernet-samba-ad krb5-workstation

# Samba Version
echo "Samba installed:"
samba -V
