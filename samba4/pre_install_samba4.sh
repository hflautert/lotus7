# Adicionar repo
wget -O /etc/yum.repos.d/sernet-samba.repo https://sernet-samba-public:Noo1oxe4zo@download.sernet.de/packages/samba/4.2/rhel/7/sernet-samba-4.2.repo

# Alterar credenciais repo
sed -i 's/USERNAME:ACCESSKEY/sernet-samba-public:Noo1oxe4zo/g' /etc/yum.repos.d/sernet-samba.repo

# Instalação de pacotes
yum -y install sernet-samba sernet-samba-ad

# Promover o domínio
echo "Samba instalado:"
samba -V
echo "Antes de provomer o domínio, ajuste seu DNS.
DNS1=x.x.x.x - Ip do proprio servidor.
DNS2=x.x.x.x - Ip de outro servidor DNS.
Search domain = dominio.com.br
A configuração pode ser feita pelo utilitário nmtui"

echo "Para promover o domínio use:"
echo "samba-tool domain provision"
echo "Para maiores informações: https://wiki.samba.org/index.php/Samba_AD_DC_HOWTO"
