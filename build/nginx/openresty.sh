#! /bin/bash
if [ -z $OPENRESTY_VERSION ]; then
	OPENRESTY_VERSION=1.11.2.3
fi
PARALLEL=`nproc`
OWD=`pwd`
mkdir build; cd build; WD=`pwd`
apt-get install -y build-essential libssl-dev libpcre++-dev automake autoconf libtool unzip zip git
wget https://openresty.org/download/openresty-$OPENRESTY_VERSION.tar.gz
git clone https://github.com/google/ngx_brotli; cd ngx_brotli; git submodule update --init; cd ..
tar zxf openresty-$OPENRESTY_VERSION.tar.gz
cd openresty-$OPENRESTY_VERSION
./configure -j$PARALLEL --user=www-data --group=www-data --with-file-aio --with-ipv6 --with-pcre-jit --with-http_realip_module --with-http_stub_status_module --with-http_v2_module --add-module=../ngx_brotli
sed -ie "s/openresty/nginx/g" build/nginx-*/src/http/ngx_http_header_filter_module.c
sed -ie "s/openresty\/\".*/nginx\"/g" build/nginx-*/src/core/nginx.h
sed -ie "s/define NGINX_VERSION.*/define NGINX_VERSION      \"stable\"/g" build/nginx-*/src/core/nginx.h
make -j$PARALLEL install
ln -s /usr/local/openresty/nginx/sbin/nginx /usr/sbin/nginx
ldconfig
cd $OWD
