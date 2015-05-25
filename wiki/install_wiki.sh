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

# Instalação de requsitos, APACHE, MYSQL, PHP:
yum install -y httpd
yum install -y mariadb-server mariadb
yum install -y php php-mysql php-gd php-xml php-intl

# Para melhor o desempenho php-xcache:
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
curl -O http://releases.wikimedia.org/mediawiki/1.24/mediawiki-1.24.2.tar.gz
tar xvzf mediawiki-*.tar.gz
mv mediawiki-1.24.2/* /var/www/html

# Ajustar SELINUX
restorecon -FR /var/www/html

# Banco de dados
echo "
Sera criado um usuario (diferente de root) para base da wiki.
Digite usuario:"
read username
echo "
Digite senha:"
read -s password

echo "CREATE DATABASE wiki_db;
GRANT INDEX, CREATE, SELECT, INSERT, UPDATE, DELETE, ALTER, LOCK TABLES ON my_wiki.* TO '$username'@'localhost' IDENTIFIED BY '$password';
FLUSH PRIVILEGES;" > temp.sql

echo "Agora digite a senha de root para conectar e criar a base no banco de dados:"
mysql -u root -p < temp.sql

# Finalizar configuração via browser.
