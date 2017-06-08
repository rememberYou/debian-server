#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Creates an user.
function create_user() {
    useradd $username -m -G users -s /bin/bash
    echo -e "$password\n$password" | (passwd $username)

    quotatool -u $username -bq 400M -l 500M /home
    #quotatool -u $username -bq 400M -l 500M /srv/share

    smbpasswd -a $username

    # Each created users, will have the possibility to connect on the 'deepblue'
    # database and will can only make 'SELECT' request.
    mysql -h localhost -u root -ptest deepblue -e "CREATE USER '$username'@'localhost' IDENTIFIED BY '$password'";
    #mysql -h localhost -u root -ptest deepblue -e "GRANT SELECT ON deepblue . * TO '$username'@'localhost'";
    mysql -h localhost -u root -ptest deepblue -e "GRANT SELECT ON deepblue.* TO '$username'@'localhost'";
    mysql -h localhost -u root -ptest deepblue -e "FLUSH PRIVILEGES";

    # Insert the username to the 'users' table of the 'deepblue' database.
    mysql -h localhost -u root -ptest deepblue -e "INSERT INTO users(username) VALUES (\"$username\")";

    # Now you can connect to the database of the user with the following
    # command:  mysql -u $username -p $password $username

    create_website $username
}

# Creates a website for a specific user.
function create_website() {
    echo "<VirtualHost *:80>" > "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tServerAdmin $username@$username.lan" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tServerName $username.lan" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tServerAlias www.$username.lan" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tDocumentRoot /srv/www/$username/www" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tErrorLog /srv/www/$username.lan/logs/error.log" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tCustomLog /srv/www/$username.lan/logs/access.log combined" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo "</VirtualHost>" >> "/etc/apache2/sites-enabled/$username.lan.conf"

    echo "" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo "Alias /$username '/srv/www/$username/www'" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "<Directory '/srv/www/$username/www'>" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tOptions Indexes FollowSymLinks MultiViews" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tAllowOverride All" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tOrder deny,allow" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tAllow from all" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo "</Directory>" >> "/etc/apache2/sites-enabled/$username.lan.conf"

    mkdir -p "/srv/www/$username/www"
    mkdir -p "/srv/www/$username.lan/logs/"
    chmod 755 "/srv/www/$username/www"
}

function create_serverPage() {
    echo "<!DOCTYPE html>" > "/srv/www/$username/www/index.html"
    echo "<html>" >> "/srv/www/$username/www/index.html"
	echo -e "\t<head>" >> "/srv/www/$username/www/index.html"
	echo -e "\t\t<meta charset=\"utf-8\">" >> "/srv/www/$username/www/index.html"
	echo -e "\t\t<title>Server page</title>" >> "/srv/www/$username/www/index.html"
	echo -e "\t</head>" >> "/srv/www/$username/www/index.html"
	echo -e "\t<body>" >> "/srv/www/$username/www/index.html"
    echo -e "\t\t<div id=\"greetings\" style=\"width: 70%; margin: 0 auto; margin-top: 30vh; text-align: center;\">" >> "/srv/www/$username/www/index.html"
	echo -e "\t\t\t<h1>Welcome $username!</h1>" >> "/srv/www/$username/www/index.html"
    echo -e "\t\t\t<h2>This is your own server page!</h2>" >> "/srv/www/$username/www/index.html"
    echo -e "\t\t<\div>" >> "/srv/www/$username/www/index.html"
	echo -e "\t</body>" >> "/srv/www/$username/www/index.html"
    echo "</html>" >> "/srv/www/$username/www/index.html"
}

echo -e "Enter the name of the user: "
read username
if id "$username" >/dev/null 2>&1; then
    echo "user already exists!"
else
    echo -e "Enter the password associted with this account: "
    read password

    create_user $username $password

    echo -e "$username user has been successfully added."
    echo -e "The ${bold}www${normal} folder of the $username user has been succesfully created."
    create_serverPage
    echo -e "\t The index.html page was created."
    /etc/init.d/apache2 reload
    #chown -R www-data:www-data /srv/www
fi
