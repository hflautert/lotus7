#!/bin/bash

# Disable SELINUX
# Here there is a TODO, you can map what you need to set on Selinux, or disable it:
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Set samba classic mode
sed -i 's/SAMBA_START_MODE="none"/SAMBA_START_MODE="classic"/g' /etc/default/sernet-samba

# Setup services
chkconfig sernet-samba-nmbd on
chkconfig sernet-samba-smbd on
chkconfig sernet-samba-winbindd on

# Restart services
systemctl restart sernet-samba-smbd
systemctl restart sernet-samba-nmbd
systemctl restart sernet-samba-winbindd
