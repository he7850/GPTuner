set -x

yum install -y java-latest-openjdk-devel

JAVAC_PATH=`rpm -ql java-latest-openjdk-devel | grep bin/javac`
JAVA_HOME=${JAVA_HOME//\/bin\/javac}

echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/profile

source /etc/profile
