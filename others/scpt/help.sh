
# install mysql5 and mysql8
brew install mysql
cp -rf /usr/local/var/mysql /usr/local/var/mysql8

brew install mysql@5.7
cp -rf /usr/local/var/mysql /usr/local/var/mysql5

cp -rf /usr/local/var/mysql5 /usr/local/var/mysql
cp -rf /usr/local/var/mysql8 /usr/local/var/mysql
rm -rf /usr/local/var/mysql


cp /usr/local/etc/my.cnf /usr/local/etc/my5.cnf
cp /usr/local/etc/my.cnf /usr/local/etc/my8.cnf


## link and unlink
brew unlink php
brew link php@7.4

brew info mysql
brew services list
brew services start mysql
brew services stop mysql
brew uninstall mysql
brew doctor
brew cleanup

ls /usr/local/Cellar/mysql # => 8.0.16


ps -ef|grep mysql

## nginx
ps -ef | grep nginx | grep -v grep

#https://github.com/shivammathur/homebrew-php

brew link --overwrite --force shivammathur/php/php@8.1
brew upgrade shivammathur/php/php@8.1

//third party brew
brew tap shivammathur/php
//install PHP
brew install shivammathur/php/php@7.3

#https://wiki.nikiv.dev/programming-languages/swift/swift-libraries/

#https://kevdees.com/macos-12-monterey-nginx-setup-multiple-php-versions/
#config

open -a TextEdit /usr/local/etc/nginx/servers/geng_nginx.conf


#mysql port
echo "show variables like \"port\""|mysql -uroot|sed 1d|awk '{print $2}'
