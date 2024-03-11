yum install -y postgresql postgresql-server postgresql-jdbc postgresql-odbc net-tools
postgresql-setup --initdb --unit postgresql

pgconf=/var/lib/pgsql/data/pg_hba.conf
sed -i 's/ident$/md5/g' $pgconf
systemctl restart postgresql

sudo -u postgres psql -c "create user postgres with password 'postgres'"
sudo -u postgres psql -c "alter user postgres with password 'postgres'"
sudo -u postgres psql -c "create database benchbase owner postgres"
sudo -u postgres psql -c "alter database benchbase owner to postgres"
sudo -u postgres psql -c "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO postgres"

sh build_benchmark.sh postgres tpch

mkdir -p ../optimization_results/postgres/log
mkdir -p ../optimization_results/temp_results
