#!/bin/bash

# Allowed to do.
mysql -u toto -ptoto deepblue -e < "SELECT * FROM users";

# Not allowed to do.
mysql -u toto -ptoto deepblue -e < "DELETE FROM users WHERE username='toto'";
