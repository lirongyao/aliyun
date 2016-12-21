#!/bin/bash
rm -rf apache-tomcat-7.0.54
if [ ! -f apache-tomcat-7.0.54.tar.gz ];then
  wget http://t-down.oss-cn-hangzhou.aliyuncs.com/apache-tomcat-7.0.54.tar.gz
fi
tar zxvf apache-tomcat-7.0.54.tar.gz
mv apache-tomcat-7.0.54/*  /alidata/server/tomcat
chmod u+x -R /alidata/server/tomcat/bin
chown www:www -R /alidata/server/tomcat/
chmod 777 -R /alidata/server/tomcat/logs
chmod 777 -R /alidata/server/tomcat/work
export JAVA_HOME=/alidata/server/java

sed -i 's/redirectPort="8443"/redirectPort="8443"\n\t\tmaxThreads="2000"\n\t\tminSpareThreads="100"\n\t\tmaxSpareThreads="1000"\n\t\tacceptCount="1000"/' /alidata/server/tomcat/conf/server.xml
#start tomcat
export JAVA_HOME=/alidata/server/java
su -s /bin/sh -c /alidata/server/tomcat/bin/startup.sh www
#add rc.local
cat /etc/issue |grep 14\..* >/dev/null
if [ ! $? -ne  0 ] ;then
    if ! cat /etc/init.d/rc.local | grep "su -s /bin/sh -c /alidata/server/tomcat/bin/startup.sh www" &> /dev/null;then
	echo "export JAVA_HOME=/alidata/server/java" >> /etc/init.d/rc.local
    echo "su -s /bin/sh -c /alidata/server/tomcat/bin/startup.sh www" >> /etc/init.d/rc.local
	echo "mount --bind  /alidata/server/tomcat/webapps/ROOT/ /alidata/www/default/" >> /etc/init.d/rc.local
    fi    
else 
    echo "it is not  ubuntu 14"
	if ! cat /etc/rc.local | grep "su -s /bin/sh -c /alidata/server/tomcat/bin/startup.sh www" &> /dev/null;then
	echo "export JAVA_HOME=/alidata/server/java" >> /etc/rc.local
    echo "su -s /bin/sh -c /alidata/server/tomcat/bin/startup.sh www" >> /etc/rc.local
	echo "mount --bind  /alidata/server/tomcat/webapps/ROOT/ /alidata/www/default/" >> /etc/rc.local
    fi	
fi

mv  /etc/init.d/tomcat7  /etc/init.d/tomcat7.bak
#/etc/init.d/tomcat7 start