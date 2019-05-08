<<!
 **********************************************************
 * Author        : wangwei
 * Email         : 2531868871@qq.com
 * Last modified : 2019-03-31 17:52
 * Filename      : install.sh
 * Description   : 1.一键安装gcc, gcc-c++, mysql8.0,
                 : 2.端口使用5890，不是默认的3306
                 : 3.数据库账号密码保存在/etc/my.cnf配置文件中
                 : 4.将mysql添加到开机自启动项,
                 : 5.可执行service nginx start|stop来启动和停止服务
                 : 6.自动修改mysql默认密码，修改root账号的host为%
 * *******************************************************
!
#!/bin/sh

oldpath=`pwd`
MY_SOFTS=/usr/local/mysofts
MYSQL_ROOT=$MY_SOFTS/mysql
MYSQL_DATA=$MYSQL_ROOT/data

SOCKET_DIR=/var/lib/mysql
MYSQL_VERSION=mysql-8.0.16-linux-glibc2.12-x86_64

yum -y install gcc
yum -y install gcc-c++
yum -y install numactl

cd /tmp
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/$MYSQL_VERSION.tar

echo "开始解压缩mysql8.0安装包，请耐心等待..."
tar -xvf $MYSQL_VERSION.tar

mkdir -p $MY_SOFTS
mkdir -p $SOCKET_DIR
chown -R mysql:mysql $SOCKET_DIR

#重命名mysql安装包，并放到/usr/local/mysofts目录下
mv $MYSQL_VERSION mysql
mv mysql $MYSQL_ROOT
cd $MYSQL_ROOT

#创建mysql用户并授权
groupadd mysql
useradd -g mysql mysql

LOG_DIR=/var/log/mysql
rm -rf $LOG_DIR
mkdir $LOG_DIR

touch $LOG_DIR/error.log
chmod 777 $LOG_DIR/error.log
chown -R mysql:mysql $LOG_DIR

mkdir -p $MYSQL_DATA
chown -R mysql:mysql $MYSQL_DATA

cd $MYSQL_ROOT
chown -R mysql:mysql .

#初始化mysql数据
bin/mysqld --initialize --user=mysql --basedir=$MYSQL_ROOT --datadir=$MYSQL_DATA
#授权当前目录给root用户
chown -R root:root ./

#授权data目录给mysql用户
chown -R mysql:mysql $MYSQL_DATA
mkdir -p $MYSQL_ROOT/tmp
chown -R mysql:mysql $MYSQL_ROOT/tmp
chmod 777 $MYSQL_ROOT/tmp

#创建my-default.cnf配置文件
cd support-files/
cat >>$MYSQL_ROOT/support-files/my-default.cnf<<EOF
[mysqld]
basedir = ${MYSQL_ROOT}
datadir = ${MYSQL_DATA}
port = 5890
socket = /tmp/mysql.sock
#skip-grant-tables
log-error = /var/log/mysql/error.log
#设置协议认证方式
default_authentication_plugin=mysql_native_password

#必填项
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
EOF

#设置my-default.cnf配置文件可访问权限
chmod 777 ./my-default.cnf

#复制my-default.cnf到/etc目录，并重命名为my.cnf
cp my-default.cnf /etc/my.cnf

#添加到服务,并设置开机自启动
#可通过命令service mysql start|stop来启动和停止mysql
#sed -i '0,/datadir=/s/datadir=/datadir=${MYSQL_DATA}/' mysql.server
cp mysql.server /etc/init.d/mysql
chmod +x /etc/init.d/mysql
chkconfig --add mysql

#查看是否添加成功
chkconfig --list mysql
#预期结果: mysqld 0:off  1:off  2:on  3:on  4:on 5:on  6:off

#开启mysql服务:
service mysql start

#删环境变量
sed -i '/export PATH/d' /etc/profile

#设置环境变量
echo "export PATH=\$PATH:${MYSQL_ROOT}/bin:${MYSQL_ROOT}/lib
" >> /etc/profile
source /etc/profile

#================================
#======修改mysql默认密码和host===
#================================
TMP_PASSWORD=`cat /var/log/mysql/error.log | grep password | head -1 | rev  | cut -d ' ' -f 1 | rev`
echo "tmp passwd: ${TMP_PASSWORD}"

NEW_PASSWORD=`openssl rand 14 -base64`

echo "new passwd: ${NEW_PASSWORD}"

echo "[mysql]" >> /etc/my.cnf
echo "user=root" >> /etc/my.cnf
echo "password=${TMP_PASSWORD}" >> /etc/my.cnf

source /etc/profile

#修改密码
mysql --connect-expired-password -e "alter user 'root'@'localhost' identified with mysql_native_password by '$NEW_PASSWORD'";

sed -i '/user=/d;/password=/d' /etc/my.cnf
echo "user=root" >> /etc/my.cnf
echo "password=${NEW_PASSWORD}" >> /etc/my.cnf

#修改host
mysql --connect-expired-password -e "use mysql;update user set host='%' where user='root';select * from user where user = 'root' \G;";

source /etc/profile
