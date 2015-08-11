#Copy Kerberos conf
cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

#Change startup mode
sed -i 's/SAMBA_START_MODE="none"/SAMBA_START_MODE="ad"/g' /etc/default/sernet-samba

#Service Startup
systemctl start sernet-samba-ad 
chkconfig sernet-samba-ad on 
chkconfig sernet-samba-smbd off 
chkconfig sernet-samba-nmbd off 
chkconfig sernet-samba-winbindd off

# Firewall Setup
# netstat -tlpn4 | grep samba
firewall-cmd --permanent --zone=public --add-port=3268/tcp
firewall-cmd --permanent --zone=public --add-port=3269/tcp
firewall-cmd --permanent --zone=public --add-port=389/tcp
firewall-cmd --permanent --zone=public --add-port=135/tcp
firewall-cmd --permanent --zone=public --add-port=464/tcp
firewall-cmd --permanent --zone=public --add-port=53/tcp
firewall-cmd --permanent --zone=public --add-port=88/tcp
firewall-cmd --permanent --zone=public --add-port=636/tcp
firewall-cmd --permanent --zone=public --add-port=1024/tcp
systemctl reload firewalld

# Selinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

Final tests and setup.
echo "Samba test
smbclient -L \\127.0.0.1 -U administrator

Setup DNS
vim /etc/resolv.conf
domain domain.sc.gov.br
nameserver 127.0.0.1
nameserver 192.168.10.1

DNS test
host -t SRV _ldap._tcp.domain.sc.gov.br.
_ldap._tcp.domain.sc.gov.br has SRV record 0 100 389 rendeira.domain.sc.gov.br.

host -t SRV _kerberos._udp.domain.sc.gov.br.
_kerberos._udp.domain.sc.gov.br has SRV record 0 100 88 rendeira.domain.sc.gov.br.

host -t A rendeira.domain.sc.gov.br.
"
