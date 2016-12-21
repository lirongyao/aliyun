------------------------- 自动安装过程 -------------------------

图文教程地址：http://help.aliyun.com/manual?spm=0.0.0.0.oMceY0&helpId=129

此安装包可在阿里云所有linux系统上部署安装。

此安装包包含的软件及版本为：
nginx：1.4.4
apache：2.2.29、2.4.10
mysql：5.1.73、5.5.40、5.6.21
php：5.2.17、5.3.29、5.4.23、5.5.7
php扩展：memcache、Zend Engine/ OPcache
jdk：1.7.0
tomcat：7.0.54
ftp：（yum/apt-get安装）
phpwind：8.7 GBK
phpmyadmin：4.1.8

安装步骤：

xshell/xftp上传sh目录

chmod –R 777 sh
cd sh
./install.sh

安装完成后请查看account.log文件，数据库密码在里面。

        
         如果有什么使用问题、bug，或者建议，可联系作者：qrj@jiagouyun.com

--------------------------- version 1.3.0 测试记录 --------------------------

以下为此脚本在阿里云linux系统测试记录（抽样测试）:
centos 5.8/64位/4核4G/50数据盘       --->测试ok
centos 5.8/64位/1核512M/30G数据盘    --->测试ok

centos 5.10/64位/4核4G/50数据盘       --->测试ok
centos 5.10/64位/1核512M/30G数据盘    --->测试ok

centos 6.5/64位/1核512M/无数据盘     --->测试ok
centos 6.5/64位/4核4G/50G数据盘      --->测试ok

redhat 5.7/64位/4核4G/50数据盘       --->测试ok
redhat 5.7/64位/1核512M/无数据盘     --->测试ok

ubuntu 12.04/64位/4核4G/50G数据盘    --->测试ok
ubuntu 12.04/64位/1核512M/无数据盘   --->测试ok

ubuntu 14.04/64位/4核4G/50G数据盘    --->测试ok
ubuntu 14.04/64位/1核512M/无数据盘   --->测试ok

debian 6.0.6/64位/1核512M/无数据盘   --->测试ok
debian 6.0.6/64位/1核512M/30G数据盘  --->测试ok

opensuse 13.1/64位/1核512M/无数据盘   --->测试ok

gentoo 13 Beta/64位/1核512M/无数据盘   --->测试ok
gentoo 13 Beta/64位/1核512M/30G数据盘  --->测试ok
