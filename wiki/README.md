#Instalação automatizada
````shell
 curl -O https://raw.githubusercontent.com/hflautert/lotus7/master/wiki/install_wiki.sh
 chmod +x install_wiki.sh
 ./install_wiki.sh
````

#Autenticações extras

Caso seja necessário proteção extra ao conteúdo.
Seguem 2 opções, apache simples e AD.

##Somente Apache
Criar arquivo .htaccess
````shell
 vim /var/www/wiki/.htaccess
 ````
 
Com o conteúdo:
````shell
 AuthType Basic
 AuthName "Acesso Restrito"
 AuthUserFile /var/www/wiki/.htpasswd
 require valid-user
````

Restrição de diretório no apache:
````shell
 vim /etc/httpd/conf.d/wiki.conf
````

Adicionar o conteúdo dentro do bloco <VirtualHost>:
````shell
 <Directory /var/www/wiki>
     Options Indexes FollowSymLinks MultiViews
     AllowOverride All
     Order allow,deny
     allow from all
 </Directory>
````

Criar arquivo com usuários e senhas:
````shell
 htpasswd -c /var/www/wiki/.htpasswd usuario1
 htpasswd /var/www/wiki/.htpasswd usuario2
````

Recarregar o apache:
````shell
 systemctl reload httpd
````

##Apache integrado com AD
Restrição de diretório no apache, integrado com AD:
````shell
 vim /etc/httpd/conf.d/wiki.conf
````

Adicionar o conteúdo dentro do bloco <VirtualHost>:
Alterar os campos '''DC=empresa,DC=com''' com os campos do respectivo cliente.
````shell
<Directory /var/www/wiki>
     AuthType Basic
     AuthBasicProvider ldap
     AuthName "AD"
     AuthLDAPURL "ldap://192.168.1.1:3268/DC=empresa,DC=com?sAMAccountName?sub?(objectClass=*)"
     AuthLDAPBindDN CN=wiki,OU=ContasdeServico,DC=empresa,DC=com
     AuthLDAPBindPassword SenhaWiki
     #Require valid-user
     Require ldap-group CN=cpd,OU=Grupos,DC=empresa,DC=com
     Options Indexes FollowSymLinks MultiViews
 </Directory>
````

Desabilitar SELINUX:
````shell
 setenforce 0
 vim /etc/selinux/config
 SELINUX=disabled
 ````
 - TODO: Mapear as permissões que impactam na autenticação com o AD.

Recarregar o apache:
````shell
 systemctl reload httpd
````
