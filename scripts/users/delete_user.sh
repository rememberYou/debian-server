#!/bin/bash

# Deletes an user.
function delete_user() {
    deluser --remove-home $username users

    rm -rf /etc/apache2/sites-enabled/$username.lan.conf
}

echo -e "Enter the username of the user to delete: "
read username

if [ ! id "$username" >/dev/null 2>&1 ]; then
    echo "The username \"$username\" doesn't exist!"
else
    delete_user $username
fi
