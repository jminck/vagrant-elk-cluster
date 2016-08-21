yum -q -y install screen

# Setting ES version to install
FILEBEAT_VERSION="filebeat-1.2.3-x86_64"

# Removing all previous potentially installed version
rm -rf filebeat
rm -rf filebeat-*

# Downloading the version to install
if [ ! -f "/vagrant/$FILEBEAT_VERSION.tar.gz" ]; then
    wget -q https://download.elastic.co/beats/filebeat/${FILEBEAT_VERSION}.tar.gz
    tar -zxf $FILEBEAT_VERSION.tar.gz
    rm -rf $FILEBEAT_VERSION.tar.gz
else
    tar -zxf /vagrant/$FILEBEAT_VERSION.tar.gz
fi

# Renaming extracted folder to a generic name to avoid changing commands 
mv $FILEBEAT_VERSION filebeat

chown -R vagrant: filebeat

firewall-cmd --zone=public --add-port=5403/tcp --permanent
firewall-cmd --zone=public --add-port=5403/udp --permanent
systemctl stop firewalld
systemctl start firewalld

#let vagrant read the log folder - !BUG! needs better solution
chmod 755 /var/log -R
chmod 744 /var/log/* 
chmod 744 /var/log/audit/*
chmod 744 /var/log/anaconda/*  
chmod 744 /var/log/tuned/*  