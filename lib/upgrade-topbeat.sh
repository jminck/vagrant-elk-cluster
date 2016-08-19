yum -q -y install screen

# Setting ES version to install
TOPBEAT_VERSION="topbeat-1.2.3-x86_64"

# Removing all previous potentially installed version
rm -rf topbeat
rm -rf topbeat-*

# Downloading the version to install
if [ ! -f "/vagrant/$TOPBEAT_VERSION.tar.gz" ]; then
    wget -q https://download.elastic.co/beats/topbeat/${TOPBEAT_VERSION}.tar.gz
    tar -zxf $TOPBEAT_VERSION.tar.gz
    rm -rf $TOPBEAT_VERSION.tar.gz
else
    tar -zxf /vagrant/$TOPBEAT_VERSION.tar.gz
fi

# Renaming extracted folder to a generic name to avoid changing commands 
mv $TOPBEAT_VERSION topbeat

chown -R vagrant: topbeat

firewall-cmd --zone=public --add-port=5403/tcp --permanent
firewall-cmd --zone=public --add-port=5403/udp --permanent
systemctl stop firewalld
systemctl start firewalld

#let vagrant read the log folder - !BUG! needs better solution
chmod 755 /var/log -R
chmod 744 /var/log/* 
chmod 744 /var/log/audit/*
chmod 744 /var/log/anaconda/*  
chmod 744 /var/log/ppp/*
chmod 744 /var/log/tuned/*  