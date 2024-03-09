# sudo apt-get update
# sudo apt-get install git
# git clone --depth 1 https://github.com/cmu-db/benchbase.git ../benchbase
git clone --depth 1 https://github.com/he7850/benchbase.git ../benchbase
cd ../benchbase
sh -x ./mvnw clean package -P $1
cd target
tar xvzf benchbase-$1.tgz
cd benchbase-$1