[How to install Magento 2.3 and build a web server](https://digitalstartup.co.uk/magento/how-to-install-magento-23/)

[Magento 2.3.x technology stack requirements](https://devdocs.magento.com/guides/v2.3/install-gde/system-requirements-tech.html)

# PHP (7.1.3+, 7.2.x)

```bash
brew search php
brew install php@7.2
```

To enable PHP in Apache add the following to httpd.conf and restart Apache:
    LoadModule php7_module /home/linuxbrew/.linuxbrew/opt/php@7.2/lib/httpd/modules/libphp7.so

    <FilesMatch \.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>

Finally, check DirectoryIndex includes index.php
    DirectoryIndex index.php index.html

The php.ini and php-fpm.ini file can be found in:
    /home/linuxbrew/.linuxbrew/etc/php/7.2/

php@7.2 is keg-only, which means it was not symlinked into /home/linuxbrew/.linuxbrew,
because this is an alternate version of another formula.

If you need to have php@7.2 first in your PATH run:
  echo 'export PATH="/home/linuxbrew/.linuxbrew/opt/php@7.2/bin:$PATH"' >> ~/.zshrc
  echo 'export PATH="/home/linuxbrew/.linuxbrew/opt/php@7.2/sbin:$PATH"' >> ~/.zshrc

For compilers to find php@7.2 you may need to set:
  export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/php@7.2/lib"
  export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/php@7.2/include"

# Composer

```bash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

ln -s composer.phar ~/.local/bin/composer
```

# Apache Web Server (httpd 2.4.x)

```bash
brew install httpd
```

DocumentRoot is `/home/linuxbrew/.linuxbrew/var/www`.

The default ports have been set in `/home/linuxbrew/.linuxbrew/etc/httpd/httpd.conf` to `8080` and in
`/home/linuxbrew/.linuxbrew/etc/httpd/extra/httpd-ssl.conf` to `8443` so that httpd can run without sudo.

# Nginx (1.x)

```bash
brew install nginx
```

# Mysql

[mysql 5.7](https://dev.mysql.com/downloads/mysql/5.7.html)

```bash
gzip -d mysql-5.7.25-linux-glibc2.12-x86_64.tar.gz
tar xvf mysql-5.7.25-linux-glibc2.12-x86_64.tar

sudo groupadd mysql
sudo useradd -r -g mysql -s /bin/false mysql
# -r, create as a system account
# -g, add to a group by group name
# -s /bin/false (the same as /bin/nologin), prevent the created user from loggin on system (would immediately log out if attempted)
sudo passwd mysql ...
ln -s mysql-5.7.25-linux-glibc2.12-x86_64/ /usr/local/mysql/
cd mysql-5.7.25-linux-glibc2.12-x86_64/
mkdir mysql-files
sudo chown mysql:mysql mysql-files
sudo chmod 750 mysql-files
sudo bin/mysqld --initialize --user=mysql
sudo bin/mysql_ssl_rsa_setup
echo "export PATH=$PATH:.../bin" >> ~/.zshenv

# Start server
mysqld_safe --user=mysql &

# CLI
mysql -h localhost -u username -p

# Stop server
mysqladmin -p -u username shutdown
```
