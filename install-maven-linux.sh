#!/bin/sh

MY_SOFTS=/usr/local/mysofts

wget wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
tar -zxvf apache-maven-3.6.1-bin.tar.gz
mv apache-maven-3.6.1 $MY_SOFTS/maven3

cat >> /etc/profile <<"EOF"
export M2_HOME=/usr/local/mysofts/maven3
export PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin
EOF
source /etc/profile
