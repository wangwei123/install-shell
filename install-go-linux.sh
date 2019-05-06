#!/bin/sh

cd /tmp
wget https://studygolang.com/dl/golang/go1.12.4.linux-amd64.tar.gz
tar -zxvf go1.12.4.linux-amd64.tar.gz

mkdir -p /usr/local/mysofts
mv go /usr/local/mysofts

cat >> /etc/profile <<"EOF"
export GO111MODULE=on
export GOPROXY=https://goproxy.io
export GOROOT=/usr/local/mysofts/go
export PATH=$PATH:$GOROOT/bin
EOF
source /etc/profile
