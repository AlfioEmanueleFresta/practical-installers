#!/bin/bash


WEBAPP_REPO="gitlab@git.cs.york.ac.uk:cyber-practicals/webapp.git"
WEBAPP_PORT=12342
WEBAPP_PATH=/home/student/webapp

PASTEBIN_REPO="gitlab@git.cs.york.ac.uk:cyber-practicals/practical-xss-requestbin.git"
PASTEBIN_PORT=12344
PASTEBIN_PATH=/var/www/pastebin

SERVER_ADMIN="cyber-practicals@york.ac.uk"

MYSQL_ROOT_PASSWORD="Pr1agDidem"
MYSQL_USER="dbuser"
MYSQL_PASSWORD="hackmeplease"
MYSQL_DBNAME="webapp"

# Apache2 Configuration
APACHE2_CONF_AVAILABLE="/etc/apache2/sites-available/"
APACHE2_CONF_ENABLED="/etc/apache2/sites-enabled/"
APACHE2_CONF_PORTS="/etc/apache2/ports.conf"
APACHE2_WEBAPP_CONF="webapp.conf"
APACHE2_PASTEBIN_CONF="pastebin.conf"

# Docs
PROJECT_DOC=$1
DOCS_REPO=gitlab@git.cs.york.ac.uk:cyber-practicals/practical-xss.git

# Install dependencies
apt-get update
apt-get install -y php5-sqlite

# Download the applications
git clone $WEBAPP_REPO $WEBAPP_PATH
git clone $PASTEBIN_REPO $PASTEBIN_PATH

# Permissions for the webapp
usermod -a -G www-data student
chown -R student:www-data $WEBAPP_PATH
chmod -R 0777 $WEBAPP_PATH

#Apache configuration
echo "
<VirtualHost *:$WEBAPP_PORT>
    ServerName Webapp
    ServerAdmin $SERVER_ADMIN
    DocumentRoot $WEBAPP_PATH
</VirtualHost>
<Directory $WEBAPP_PATH>
	Options FollowSymLinks
	Require all granted
	DirectoryIndex index.php
	<IfModule mod_php5.c>
		AddType application/x-httpd-php .php
		php_value include_path .
	</IfModule>
</Directory>
" > $APACHE2_CONF_AVAILABLE$APACHE2_WEBAPP_CONF

echo "
<VirtualHost *:$PASTEBIN_PORT>
    ServerName Pastebin
    ServerAdmin $SERVER_ADMIN
    DocumentRoot $PASTEBIN_PATH
</VirtualHost>
<Directory $PASTEBIN_PATH>
	Options FollowSymLinks
	Require all granted
	DirectoryIndex index.php
	<IfModule mod_php5.c>
		AddType application/x-httpd-php .php
		php_value include_path .
	</IfModule>
</Directory>
" > $APACHE2_CONF_AVAILABLE$APACHE2_PASTEBIN_CONF

# Make Apache2 Listen on additional ports
echo "Listen $WEBAPP_PORT" >> $APACHE2_CONF_PORTS
echo "Listen $PASTEBIN_PORT" >> $APACHE2_CONF_PORTS

# Link Apache2 Configurations
ln -s $APACHE2_CONF_AVAILABLE$APACHE2_WEBAPP_CONF $APACHE2_CONF_ENABLED
ln -s $APACHE2_CONF_AVAILABLE$APACHE2_PASTEBIN_CONF $APACHE2_CONF_ENABLED

# Set permissions and restart Apache2 to load new configuration
chown -R www-data $PASTEBIN_PATH
/etc/init.d/apache2 restart

# Create MySQL user and database
sed -i -e "s/dbname=dbname/dbname=$MYSQL_DBNAME/g" $WEBAPP_PATH/inc/configuration.php
echo "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';" | mysql -u root -p$MYSQL_ROOT_PASSWORD
echo "CREATE DATABASE $MYSQL_DBNAME;" | mysql -u root -p$MYSQL_ROOT_PASSWORD
echo "GRANT ALL ON $MYSQL_DBNAME.* TO $MYSQL_USER;" | mysql -u root -p$MYSQL_ROOT_PASSWORD
cat $WEBAPP_PATH/database/setup.sql | mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DBNAME

echo "Generating documentation..."
TMPDIR=`mktemp -d`
git clone $DOCS_REPO $TMPDIR
cd $TMPDIR/
make html
mv _build/html $PROJECT_DOC
rm -rf $TMPDIR

echo " "
echo "Done -- Webapp installed in.......: $WEBAPP_PATH"
echo "        Webapp listening at.......: http://0.0.0.0:$WEBAPP_PORT"
echo "        Pastebin installed in.....: $PASTEBIN_PATH"
echo "        Pastebin listening at.....: http://0.0.0.0:$PASTEBIN_PORT"
echo "        Documentation installed in: $PROJECT_DOC"
