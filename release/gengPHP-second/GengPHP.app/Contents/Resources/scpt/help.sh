
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
