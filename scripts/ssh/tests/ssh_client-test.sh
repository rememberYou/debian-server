#!/bin/bash

# Enter to the server without permission.
ssh -p 62000 terencio@10.1.215.223

# Register the public RSA key to the server, after that the password authentication
# is open.
ssh-copy-id -i ~/.ssh/id_rsa_pub -p 62000 terencio@10.1.215.223

# After that the public key RSA key is registered on the server, close the password
# authentification.
