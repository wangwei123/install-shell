#!/bin/sh
#author wangwei

MY_SOFTS=/usr/local/mysofts

if [ ! -d "${MY_SOFTS}" ]; then
    mkdir $MY_SOFTS
fi

cd $MY_SOFTS
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz"

tar  -zxvf jdk-8u141-linux-x64.tar.gz

sed -i '/JAVA_HOME/d;/CLASS_PATH/d;/JRE_HOME/d' /etc/profile
chmod 775 /etc/profile

cat >> /etc/profile <<"EOF"
JAVA_HOME=/usr/local/mysofts/jdk1.8.0_141 
JRE_HOME=$JAVA_HOME/jre 
CLASS_PATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin 
export JAVA_HOME JRE_HOME CLASS_PATH PATH 
EOF

source /etc/profile

