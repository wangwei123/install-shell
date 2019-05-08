<<!
 **********************************************************
 * Author        : wangwei
 * Email         : 2531868871@qq.com
 * Last modified : 2019-03-31 17:52
 * Filename      : install-go-linux.sh
 * Description   : 1.一键安装go1.12.4
 * *******************************************************
!
#!/bin/sh

MY_SOFTS=/usr/local/mysofts
GO_VERSION=1.12.4

mkdir -p $MY_SOFTS
cd /tmp

wget https://studygolang.com/dl/golang/go$GO_VERSION.linux-amd64.tar.gz
tar -zxvf go$GO_VERSION.linux-amd64.tar.gz
mv go $MY_SOFTS/
ln -s $MY_SOFTS/go/bin/* /usr/bin/

cat >> /etc/profile <<"EOF"
export GO111MODULE=on
export GOPROXY=https://goproxy.io
export GOROOT=/usr/local/mysofts/go
export PATH=$PATH:$GOROOT/bin
EOF

source /etc/profile
