<<!
 **********************************************************
 * Author        : wangwei
 * Email         : 2531868871@qq.com
 * Last modified : 2019-03-31 17:52
 * Filename      : install-tomcat-linux.sh
 * Description   : 1.一键安装tomcat
 * *******************************************************
!

#!/bin/sh

MY_SOFTS=/usr/local/mysofts
TOMCAT_VERSION=9.0.13
TOMCAT_NAME=apache-tomcat-9.0.13

mkdir -p $MY_SOFTS

cd /tmp
wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/TOMCAT_NAME.tar.gz 
tar -zxvf $TOMCAT_NAME.tar.gz

rm -rf $MY_SOFTS/tomcat9
mv $TOMCAT_NAME $MY_SOFTS/tomcat9

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
