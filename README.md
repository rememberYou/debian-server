![Debian Logo](assets/logo.png "Debian logo") Debian Server
===============================

For education purpose, this project was to give a try to configure a Debian server, by
implementing the various services in terms of security and good manners
that a sysadmin should have.

For the French community, a report about the project is available on `report`.

Feel free to use our code for your own server and contribute to this repository if
you notice any mistakes.

--------------------

### Usage ###

After installing a Debian server, execute the server and/or the client configuration.

Example for installing Samba:

	git clone git@github.com:rememberYou/Debian-server.git
	cd Debian-server/scripts/samba
	chmod +x samba-conf.sh
	./samba-conf.sh
	
Don't forget to change the IPv4 address of your server and of your client for the scripts.

--------------------

### Services supporting [9/9] ###
   - [x] NFS share
   - [x] Samba share
   - [x] Web server
   - [x] FTP server
   - [x] MySQL server
   - [x] Backups
   - [x] DNS server
   - [x] NTP
   - [x] SSH

--------------------

### Good idea for improvements ###
   - [ ] SELinux
   - [ ] Make a backup system with [borg](https://borgbackup.readthedocs.io/en/stable/)
   - [ ] Fix the vsftpd problem
   - [ ] Allow users to reach www.$username.lan with DNS
