rm /var/lib/pgsql/data/postgresql.auto.conf
sleep 2
#su - postgres
su postgres -c 'pg_ctl restart -D /var/lib/pgsql/data/ -o "-c config_file=/var/lib/pgsql/data/postgresql.conf"'
