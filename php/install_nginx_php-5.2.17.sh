#!/bin/bash
rm -rf php-5.2.17
rm -rf php-5.2.17-fpm-0.5.14.diff.gz
rm -rf txtbgxGXAvz4N.txt
wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/php-5.2/txtbgxGXAvz4N.txt
if [ ! -f php-5.2.17.tar.gz ];then
  wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/php-5.2/php-5.2.17.tar.gz
fi
if [ ! -f php-5.2.17-fpm-0.5.14.diff.gz ];then
  wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/php-5.2/php-5.2.17-fpm-0.5.14.diff.gz
fi
gunzip php-5.2.17-fpm-0.5.14.diff.gz

tar zxvf php-5.2.17.tar.gz
patch -d php-5.2.17 -p1 < php-5.2.17-fpm-0.5.14.diff



cd php-5.2.17
./configure --prefix=/alidata/server/php \
--with-config-file-path=/alidata/server/php/etc \
--with-mysql=/alidata/server/mysql \
--with-mysqli=/alidata/server/mysql/bin/mysql_config \
--with-pdo-mysql=/alidata/server/mysql \
--enable-fpm \
--enable-fastcgi \
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
--with-openssl \
--disable-maintainer-zts \
--disable-safe-mode \
--disable-fileinfo

cp -p ../txtbgxGXAvz4N.txt  ./php-5.2.17.patch
patch -p0 -b < ./php-5.2.17.patch
sleep 3

wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/php-5.2/debian_patches_disable_SSLv2_for_openssl_1_0_0.patch
patch -p1 < debian_patches_disable_SSLv2_for_openssl_1_0_0.patch
 
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make ZEND_EXTRA_LIBS='-liconv' -j$CPU_NUM
else
    make ZEND_EXTRA_LIBS='-liconv'
fi
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
#adjust php-fpm
cp /alidata/server/php/etc/php-fpm.conf /alidata/server/php/etc/php-fpm.conf.bak
sed -ri 's,.*name="user".*,\t\t\t<value name="user">www</value> ,g'   /alidata/server/php/etc/php-fpm.conf
sed -ri 's,.*name="group".*,\t\t\t<value name="group">www</value>,g'   /alidata/server/php/etc/php-fpm.conf
sed -i 's,^pm.min_spare_servers = 1,pm.min_spare_servers = 5,g'   /alidata/server/php/etc/php-fpm.conf
sed -i 's,^pm.max_spare_servers = 3,pm.max_spare_servers = 35,g'   /alidata/server/php/etc/php-fpm.conf
sed -i 's,^pm.max_children = 5,pm.max_children = 100,g'   /alidata/server/php/etc/php-fpm.conf
sed -i 's,^pm.start_servers = 2,pm.start_servers = 20,g'   /alidata/server/php/etc/php-fpm.conf
sed -i 's,;pid = run/php-fpm.pid,pid = run/php-fpm.pid,g'   /alidata/server/php/etc/php-fpm.conf
sed -i 's,;error_log = log/php-fpm.log,error_log = /alidata/log/php/php-fpm.log,g'   /alidata/server/php/etc/php-fpm.conf
sed -i 's,;slowlog = log/$pool.log.slow,slowlog = /alidata/log/php/\$pool.log.slow,g'   /alidata/server/php/etc/php-fpm.conf
#self start
install -v -m755 ./php-5.2.17/sapi/cgi/fpm/php-fpm  /etc/init.d/php-fpm
/etc/init.d/php-fpm start
sleep 5