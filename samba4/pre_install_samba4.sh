# Add repo
wget -O /etc/yum.repos.d/sernet-samba.repo https://sernet-samba-public:Noo1oxe4zo@download.sernet.de/packages/samba/4.2/rhel/7/sernet-samba-4.2.repo

# Set repo credentials
sed -i 's/USERNAME:ACCESSKEY/sernet-samba-public:Noo1oxe4zo/g' /etc/yum.repos.d/sernet-samba.repo

# Installing packages
yum -y install sernet-samba sernet-samba-ad krb5-workstation

# Samba Version
echo "Samba installed:"
samba -V

# Provisioning
echo "
Use the following command to provisioning:
samba-tool domain provision --use-rfc2307 --interactive
More info:
https://wiki.samba.org/index.php/Samba_AD_DC_HOWTO
"
