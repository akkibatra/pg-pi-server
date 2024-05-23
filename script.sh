#!/bin/bash

DB_NAME="mydb"
DB_USER="myuser"
DB_USER_PASS="mypassword"

# update repositories
sudo apt -y update && sudo apt -y upgrade

# install postgresql server
sudo apt install curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt update
sudo apt -y install postgresql

# create user with password
sudo su postgres -c "createdb $DB_NAME"
sudo su postgres -c "createuser $DB_USER -P --interactive;"

# open to other networks
sudo echo "host all $DB_USER    0.0.0.0/0   md5" >> /etc/postgresql/15/main/pg_hba.conf
sudo echo "listen_addresses = '*'" >> /etc/postgresql/15/main/postgresql.conf

# restart postgresql
sudo systemctl restart postgresql