# Configuração do Kerberos
cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

# Alterar inicialização
sed -i 's/SAMBA_START_MODE="none"/SAMBA_START_MODE="ad"/g' /etc/default/sernet-samba

# Configrar inicialização dos serviços
chkconfig sernet-samba-ad on 
chkconfig sernet-samba-smbd off 
chkconfig sernet-samba-nmbd off 
chkconfig sernet-samba-winbindd off

# Liberações do firewall
# https://bugs.centos.org/view.php?id=7407
# TODO after bug: https://wiki.samba.org/index.php/Samba_port_usage
systemctl disable firewalld
systemctl stop firewalld

# Selinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Reiniciar samba - apos provisão
systemctl restart sernet-samba-ad

# Testes e configurações finais
echo "Samba test
smbclient -L \\\127.0.0.1 -U administrator

DNS test
host -t SRV _ldap._tcp.domain.sc.gov.br.
_ldap._tcp.domain.sc.gov.br has SRV record 0 100 389 rendeira.domain.sc.gov.br.

host -t SRV _kerberos._udp.domain.sc.gov.br.
_kerberos._udp.domain.sc.gov.br has SRV record 0 100 88 rendeira.domain.sc.gov.br.

host -t A rendeira.domain.sc.gov.br.
"
