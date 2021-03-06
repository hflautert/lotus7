#!/bin/bash

# Instalador wikimedia
# 19/05/2015
# CentOS7
# hflautert@gmail.com

# Antes de iniciar a instalação
# -> Configurar a rede
# nmcli d
# nmtui
# -> Atualizar sistema
# yum update -y
# -> Reiniciar
# reboot

# Variaveis
wiki_down_url="http://releases.wikimedia.org/mediawiki/1.25/mediawiki-1.25.1.tar.gz"
wiki_file_name="mediawiki-1.25.1.tar.gz"
wiki_x_folder="mediawiki-1.25.1"

# Instalação de requsitos, APACHE, MYSQL, PHP:
yum install -y httpd
yum install -y mariadb-server mariadb
yum install -y php php-mysql php-gd php-xml php-intl mod_ldap

# Para melhor o desempenho, php-xcache:
yum install -y epel-release
yum install -y php-xcache

# Configuração de requisitos:
systemctl start httpd
systemctl enable httpd
firewall-cmd --permanent --add-service=http
systemctl restart firewalld

systemctl start mariadb
systemctl enable mariadb

echo "
Pressione <enter> para configurar o mysql com mysql_secure_installation.
"
read

mysql_secure_installation

# Baixar versao atual estavel
curl -O $wiki_down_url
tar xvf $wiki_file_name
mkdir /var/www/wiki
mv $wiki_x_folder/* /var/www/wiki

# Configuração APACHE
echo "
Digite o endereço para acessar esta wiki, ex: wiki.empresa.com.br :"
read vhost

echo "
O apache será configurado com: $vhost, lembre-se de criar esta entrada em seu servidor de DNS."

cat << EOF > /etc/httpd/conf.d/wiki.conf
<VirtualHost *:80>
    ServerName $vhost
    DocumentRoot /var/www/wiki
    ErrorLog /var/log/httpd/wiki-error_log
    CustomLog /var/log/httpd/wiki-access_log combined
</VirtualHost>
EOF

# Ajustar SELINUX e permissoes
restorecon -FR /var/www/wiki
chown -R root:apache /var/www/wiki

# Reiniciar apache
systemctl reload httpd

# Banco de dados
echo "
Sera criado um usuario wiki_adm para gerenciar a base da da wiki.
Digite senha:"
read -s password

cat << EOF > ~/temp.sql
CREATE DATABASE my_wiki;
GRANT INDEX, CREATE, SELECT, INSERT, UPDATE, DELETE, ALTER, LOCK TABLES ON my_wiki.* TO 'wiki_adm'@'localhost' IDENTIFIED BY '$password';
FLUSH PRIVILEGES;
EOF

echo "
O instalador irá conectar no banco e criar a base no banco de dados.
Digite a senha de root, definida anteriormente no mysql_secure_installation:"
mysql -u root -p < ~/temp.sql

rm ~/temp.sql

echo "
### Dados da instalação ###
Servidor da base de dados: localhost
Nome da base de dados: my_wiki
Nome de usuário do banco de dados: wiki_adm
Senha do banco de dados: $password

### Dicas ###
Ativar o XCache para agilizar o carregamento das páginas (Será solicitado na configuração WEB).
Personalize a wiki, salve o logo da empresa em:
/var/www/wiki/resources/assets/wiki.png

### Próximo passo ###
Para finalizar a configuração acesse:
http://$vhost
"
