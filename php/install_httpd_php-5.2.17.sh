#!/bin/bash
rm -rf php-5.2.17
rm -rf txtbgxGXAvz4N.txt
wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/php-5.2/txtbgxGXAvz4N.txt
if [ ! -f php-5.2.17.tar.gz ];then
    wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/php-5.2/php-5.2.17.tar.gz
fi
tar zxvf php-5.2.17.tar.gz
cat /etc/issue |grep 14\..* >/dev/null
if [ ! $? -ne  0 ] ;then
   apt-get -y install libmcrypt-dev build-essential libncurses5-dev libfreetype6-dev libxml2-dev mysql-client libmysqld-dev  libssl-dev libjpeg62-dev  libpng12-dev libfreetype6-dev libsasl2-dev autoconf libperl-dev libtool libaio*
   ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient_r.so /usr/lib/libmysqlclient_r.so
   ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.so /usr/lib/libmysqlclient.so
   
   cd php-5.2.17
   ./configure --prefix=/alidata/server/php \
   --with-config-file-path=/alidata/server/php/etc \
   --with-apxs2=/alidata/server/httpd/bin/apxs \
   --with-mysql=/alidata/server/mysql \
   --with-pdo-mysql=/alidata/server/mysql \
   --enable-static \
   --enable-maintainer-zts \
   --enable-zend-multibyte \
   --enable-inline-optimization \
   --enable-sockets \
   --enable-wddx \
   --enable-zip \
   --enable-calendar \
   --enable-bcmath \
   --enable-soap \
   --with-zlib \
   --with-iconv \
   --with-gd \
   --with-xmlrpc \
   --enable-mbstring \
   --without-sqlite \
   --with-curl \
   --enable-ftp \
   --with-mcrypt  \
   --with-freetype-dir=/usr/local/freetype.2.1.10 \
   --with-jpeg-dir=/usr/local/jpeg.6 \
   --with-png-dir=/usr/local/libpng.1.2.50 \
   --disable-ipv6 \
   --disable-debug \
   --disable-maintainer-zts \
   --disable-safe-mode \
   
   cp -p ../txtbgxGXAvz4N.txt  ./php-5.2.17.patch
   patch -p0 -b < ./php-5.2.17.patch
   sleep 3

   make ZEND_EXTRA_LIBS='-liconv'
   make install
   
   cd ..
   cp ./php-5.2.17/php.ini-recommended /alidata/server/php/etc/php.ini
   #adjust php.ini
   sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "/alidata/server/php/lib/php/extensions/no-debug-non-zts-20060613/"#'  /alidata/server/php/etc/php.ini
   sed -i 's#extension_dir = \"\.\/\"#extension_dir = "/alidata/server/php/lib/php/extensions/no-debug-non-zts-20060613/"#'  /alidata/server/php/etc/php.ini
   sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /alidata/server/php/etc/php.ini
   sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /alidata/server/php/etc/php.ini
   sed -i 's/;date.timezone =/date.timezone = PRC/g' /alidata/server/php/etc/php.ini
   sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /alidata/server/php/etc/php.ini
   sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /alidata/server/php/etc/php.ini
   
   /etc/init.d/httpd restart
   
   sed -i 's/sizeof(tm), 0/0, sizeof(tm)/g' ./php-5.2.17/ext/zip/lib/zip_dirent.c
   cd ./php-5.2.17/ext/mysqli/
   /alidata/server/php/bin/phpize
   ./configure --with-php-config=/alidata/server/php/bin/php-config  --with-mysqli=/alidata/server/mysql/bin/mysql_config
   make
   make install
   
else 
   echo "it is not  ubuntu 14"
   cd php-5.2.17
   ./configure --prefix=/alidata/server/php \
   --with-config-file-path=/alidata/server/php/etc \
   --with-apxs2=/alidata/server/httpd/bin/apxs \
   --with-mysql=/alidata/server/mysql \
   --with-mysqli=/alidata/server/mysql/bin/mysql_config \
   --with-pdo-mysql=/alidata/server/mysql \
   --enable-static \
   --enable-maintainer-zts \
   --enable-zend-multibyte \
   --enable-inline-optimization \
   --enable-sockets \
   --enable-wddx \
   --enable-zip \
   --enable-calendar \
   --enable-bcmath \
   --enable-soap \
   --with-zlib \
   --with-iconv \
   --with-gd \
   --with-xmlrpc \
   --enable-mbstring \
   --without-sqlite \
   --with-curl \
   --enable-ftp \
   --with-mcrypt  \
   --with-freetype-dir=/usr/local/freetype.2.1.10 \
   --with-jpeg-dir=/usr/local/jpeg.6 \
   --with-png-dir=/usr/local/libpng.1.2.50 \
   --disable-ipv6 \
   --disable-debug \
   --disable-maintainer-zts \
   --disable-safe-mode \
   
   cp -p ../txtbgxGXAvz4N.txt  ./php-5.2.17.patch
   patch -p0 -b < ./php-5.2.17.patch
   sleep 3
   make  ZEND_EXTRA_LIBS='-liconv'
   make install
   cd ..
   cp ./php-5.2.17/php.ini-recommended /alidata/server/php/etc/php.ini
   #adjust php.ini
   sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "/alidata/server/php/lib/php/extensions/no-debug-non-zts-20060613/"#'  /alidata/server/php/etc/php.ini
   sed -i 's#extension_dir = \"\.\/\"#extension_dir = "/alidata/server/php/lib/php/extensions/no-debug-non-zts-20060613/"#'  /alidata/server/php/etc/php.ini
   sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /alidata/server/php/etc/php.ini
   sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /alidata/server/php/etc/php.ini
   sed -i 's/;date.timezone =/date.timezone = PRC/g' /alidata/server/php/etc/php.ini
   sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /alidata/server/php/etc/php.ini
   sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /alidata/server/php/etc/php.ini
   
   /etc/init.d/httpd restart
fi

/etc/init.d/httpd restart
sleep 5
