#!/bin/bash

# For the incremental backup.
rsync -aAX --delete --info=progress2 --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/srv/share"} /mnt/incremental /
