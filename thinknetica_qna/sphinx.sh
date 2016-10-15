#!/bin/bash
# sphinx on ubuntu
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-sphinx-on-ubuntu-14-04

# less security? yes!
if [[ -e '/etc/SuSE-release' ]]
then
  echo Running on openSLES
  sudo /bin/sed -i 's/ident/trust/g' /var/lib/pgsql/data/pg_hba.conf
else
  echo Running on Ubuntu
  sudo /bin/sed -i 's/md5/trust/g' /etc/postgresql/9.3/main/pg_hba.conf
fi

bundle exec rake ts:configure
bundle exec rake ts:start
bundle exec rake ts:index
bundle exec rake ts:stop
