#!/bin/sh
#author wangwei

MY_SOFTS=/usr/local/mysofts
TOMCAT_VERSION=apache-tomcat-9.0.13

mkdir -p $MY_SOFTS

cd /tmp
wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-9/v9.0.13/bin/apache-tomcat-9.0.13.tar.gz
tar -zxvf $TOMCAT_VERSION.tar.gz

rm -rf $MY_SOFTS/tomcat9
mv $TOMCAT_VERSION $MY_SOFTS/tomcat9

cp $MY_SOFTS/tomcat9/bin/catalina.sh /etc/init.d/tomcat
sed -i '2i#chkconfig:2345 10 90' /etc/init.d/tomcat
sed -i '3i#description:Tomcat service' /etc/init.d/tomcat
sed -i '4iCATALINA_HOME=/usr/local/mysofts/tomcat9' /etc/init.d/tomcat
sed -i '5iJAVA_HOME=$JAVA_HOME' /etc/init.d/tomcat

chkconfig --add /etc/init.d/tomcat
chmod 755 /etc/init.d/tomcat
chkconfig --add tomcat
chkconfig tomcat on
service tomcat start

source /etc/profile
