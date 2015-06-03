A Wikimedia é uma base de conhecimento, usada para entregar a documentação do cliente e permitir atualizações posteriores.
<br>
Para instalar basta fazer a instalação '''minimal do CentOS7''', em seguida rodar a instalação automatizada.

=Instalação automatizada=

 curl -O https://raw.githubusercontent.com/hflautert/lotus7/master/wiki/install_wiki.sh
 chmod +x install_wiki.sh
 ./install_wiki.sh

=Autenticações extras=

Em alguns casos são gravadas senhas de acesso na wiki, neste caso deve-se configurar autenticação extra.
<br>
Temos 2 opções, caso o cliente não tenha AD, podemos usar '''Somente Apache'''.<br>
Já no caso do AD, aproveitamos a base para autenticar.
==Somente Apache==
Criar arquivo .htaccess
 vim /var/www/wiki/.htaccess
Com o conteúdo:
 AuthType Basic
 AuthName "Acesso Restrito"
 AuthUserFile /var/www/wiki/.htpasswd
 require valid-user

Restrição de diretório no apache:
 vim /etc/httpd/conf.d/wiki.conf
Adicionar o conteúdo dentro do bloco <VirtualHost>:
 <Directory /var/www/wiki>
     Options Indexes FollowSymLinks MultiViews
     AllowOverride All
     Order allow,deny
     allow from all
 </Directory>

Criar arquivo com usuários e senhas:
 htpasswd -c /var/www/wiki/.htpasswd usuario1
 htpasswd /var/www/wiki/.htpasswd usuario2

Recarregar o apache:
 systemctl reload httpd

==Apache integrado com AD==
Restrição de diretório no apache, integrado com AD:
 vim /etc/httpd/conf.d/wiki.conf

Adicionar o conteúdo dentro do bloco <VirtualHost>:
* Alterar os campos '''DC=empresa,DC=com''' com os campos do respectivo cliente.
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

Desabilitar SELINUX:
 setenforce 0
 vim /etc/selinux/config
 SELINUX=disabled
* TODO: Mapear as permissões que impactam na autenticação com o AD.
Recarregar o apache:
 systemctl reload httpd
