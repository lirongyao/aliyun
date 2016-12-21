#!/bin/bash

if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi
ifrpm=$(cat /proc/version | grep -E "redhat|centos")
ifdpkg=$(cat /proc/version | grep -Ei "ubuntu|debian")
ifcentos=$(cat /proc/version | grep centos)
ifubuntu=$(cat /proc/version | grep ubuntu)
ifgentoo=$(cat /proc/version | grep -i gentoo)
ifsuse=$(cat /proc/version | grep -i suse)
ifAliCloud=$(cat /proc/version | grep AliCloud)

if [ "$ifrpm" != "" ];then
	yum -y install vsftpd
	\cp -f ./ftp/config-ftp/rpm_ftp/* /etc/vsftpd/
elif [ "$ifAliCloud" != "" ];then
    yum -y install vsftpd
	\cp -f ./ftp/config-ftp/rpm_ftp/* /etc/vsftpd/
elif [ "$ifdpkg" != "" ];then
	apt-get -y install vsftpd
	if cat /etc/shells | grep /sbin/nologin ;then
		echo ""
	else
		echo /sbin/nologin >> /etc/shells
	fi
	\cp -fR ./ftp/config-ftp/apt_ftp/* /etc/
elif [ "$ifgentoo" != "" ];then
	emerge vsftpd
	\cp -f ./ftp/config-ftp/gentoo_ftp/* /etc/vsftpd/
	mv /etc/ftpusers /etc/ftpusers.bak
elif [ "$ifsuse" != "" ];then
	zypper install -y vsftpd
	\cp -f ./ftp/config-ftp/opensuse_ftp/* /etc/
	echo "/sbin/nologin" >> /etc/shells
fi

if [ "$ifcentos" != "" ] && [ "$machine" == "i686" ];then
    rm -rf /etc/vsftpd/vsftpd.conf
	\cp -f ./ftp/config-ftp/vsftpdcentosi686.conf /etc/vsftpd/vsftpd.conf
fi

if [ "$ifubuntu" != "" ];then
    mv /etc/pam.d/vsftpd /etc/pam.d/vsftpd.bak
	ln -s /lib/init/upstart-job  /etc/init.d/vsftpd
fi

cat /etc/redhat-release |grep 7\..*|grep -i centos>/dev/null
if [ ! $? -ne  0 ] ;then
   systemctl start vsftpd.service
else 
   /etc/init.d/vsftpd start
fi

chown -R www:www /alidata/www

#bug kill: '500 OOPS: vsftpd: refusing to run with writable root inside chroot()'
chmod a-w /alidata/www

MATRIX="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
LENGTH="9"
while [ "${n:=1}" -le "$LENGTH" ]
do
	PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
	let n+=1
done
if [ "$ifrpm" != "" ];then
echo $PASS | passwd --stdin www
else
echo "www:$PASS" | chpasswd
fi

sed -i s/'ftp_password'/${PASS}/g account.log