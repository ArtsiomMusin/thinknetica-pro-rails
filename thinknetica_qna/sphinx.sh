#!/bin/bash

rake ts:start
rake ts:index

# less security? yes!
sudo /bin/sed -i 's/md5/trust/g' /etc/postgresql/9.3/main/pg_hba.conf
