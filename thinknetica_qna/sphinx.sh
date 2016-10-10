#!/bin/bash
# sphinx on ubuntu
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-sphinx-on-ubuntu-14-04

bundle exec rake ts:configure
bundle exec rake ts:start
bundle exec rake ts:index

# less security? yes!
sudo /bin/sed -i 's/md5/trust/g' /etc/postgresql/9.3/main/pg_hba.conf
