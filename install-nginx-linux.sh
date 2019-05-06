<<!
 **********************************************************
 * Author        : wangwei
 * Email         : 2531868871@qq.com
 * Last modified : 2019-03-31 17:52
 * Filename      : install.sh
 * Description   : 一键安装gcc, gcc-c++, nginx和其它依赖项,
                 : 将nginx添加到开机自启动项,
                 : 可执行service nginx start|stop来启动和停止服务
 * *******************************************************
!
#!/bin/bash

MY_SOFTS_DIR="/usr/local/mysofts"
NGINX_VERSION=nginx-1.16.0
OPENSSL_VERSION=openssl-1.1.0j

yum install -y gcc gcc-c++
yum install -y zlib*
yum install -y pcre pcre-devel

rm -rf /usr/bin/pod2man
mkdir -p $MY_SOFTS_DIR

cd /tmp
wget http://nginx.org/download/$NGINX_VERSION.tar.gz
tar -zxvf $NGINX_VERSION.tar.gz 

wget https://www.openssl.org/source/$OPENSSL_VERSION.tar.gz
tar -zxvf $OPENSSL_VERSION.tar.gz

cd $NGINX_VERSION
./configure --prefix=$MY_SOFTS_DIR/nginx --with-http_v2_module --with-http_stub_status_module --with-http_ssl_module --with-stream --with-openssl=../$OPENSSL_VERSION
make && make install

rm -rf /etc/init.d/nginx
cat >> /etc/init.d/nginx <<EOF
#!/bin/bash
# Startup script for the nginx Web Server
# chkconfig: - 85 15
# description: nginx is a World Wide Web server. It is used to serve

NGINX=${MY_SOFTS_DIR}/nginx/sbin/nginx
start()
{
    \$NGINX
    echo "nginx启动成功!"
}
stop()
{
    PID=\$(ps -ef | grep "nginx" | grep -v grep | awk '{print \$2}')
    kill -9 \${PID}
    echo "nginx已关闭!"
}
restart()
{
    PID=\$(ps -ef | grep "nginx" | grep -v grep | awk '{print \$2}')
    kill -9 \${PID}	
    $NGINX
    echo "nginx重启成功!"
}
case \$1 in
"start") start
	;;
"stop") stop
	;;
"restart") restart
	;;
*) echo "请输入正确的操作参数start|stop|restart"
	;;
esac
EOF
chkconfig --add /etc/init.d/nginx
chmod 755 /etc/init.d/nginx
chkconfig --add nginx
chkconfig --level 345 nginx on
service nginx start

echo "==========安装完毕！============"
