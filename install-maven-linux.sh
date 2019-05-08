<<!
 **********************************************************
 * Author        : wangwei
 * Email         : 2531868871@qq.com
 * Last modified : 2019-03-31 17:52
 * Filename      : install-maven-linux.sh
 * Description   : 1.一键安装maven
 * *******************************************************
!
#!/bin/sh

MAVEN_VERSION=3.6.1
MAVEN_NAME=apache-maven-$MAVEN_VERSION
MY_SOFTS=/usr/local/mysofts

wget wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/$MAVEN_VERSION/binaries/$MAVEN_NAME.bin.tar.gz  
tar -zxvf $MAVEN_NAME.bin.tar.gz
mv $MAVEN_NAME $MY_SOFTS/maven3

cat >> /etc/profile <<"EOF"
export M2_HOME=/usr/local/mysofts/maven3
export PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin
EOF
source /etc/profile
