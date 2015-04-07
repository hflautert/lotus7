#!/bin/bash
# Instalação automatizada do Squid (Basico)
# hflautert@gmail.com
# 07 de Abril de 2015

# Variaveis
IP=$(ip a | grep "inet " | grep -v "127.0.0.1" | awk {'print $2'} | cut -d/ -f1)

# Inicialmente desativa o firewall padrao
# TODO - Criar regras especificas.
systemctl disable firewalld
systemctl stop firewalld

# Instalar squid
yum install squid -y

# Habilita cache padrao na configuração.
sed -i "s/#cache_dir/cache_dir/g" /etc/squid/squid.conf

# Ativar servico na inicializacao
systemctl enable squid.service

# Inicia servico
systemctl start squid.service

echo "

O squid foi instalado.

Para conferir o serviço digite:
systemctl status squid.service

Configure o proxy da estação com:
$IP:3128

Para conferir os logs:
tailf /var/log/squid/access.log

"
