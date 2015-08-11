# Adicionar repo
wget -O /etc/yum.repos.d/sernet-samba.repo https://sernet-samba-public:Noo1oxe4zo@download.sernet.de/packages/samba/4.2/rhel/7/sernet-samba-4.2.repo --no-check-certificate

# Alterar credenciais repo
sed -i 's/USERNAME:ACCESSKEY/sernet-samba-public:Noo1oxe4zo/g' /etc/yum.repos.d/sernet-samba.repo

# Instalação de pacotes
# Erro certificado - contorno:
# vim /etc/yum.repos.d/sernet-samba.repo
# sslverify=0
yum -y install sernet-samba sernet-samba-ad

# Promover o domínio
echo "Samba instalado:"
samba -V
echo "Para promover o domínio use:"
echo "samba-tool domain provision"
echo "https://wiki.samba.org/index.php/Samba_AD_DC_HOWTO"