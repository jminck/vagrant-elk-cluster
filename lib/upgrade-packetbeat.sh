yum -q -y install screen

# Setting ES version to install
PACKETBEAT_VERSION="packetbeat-1.2.3-x86_64"
# Removing all previous potentially installed version
rm -rf packetbeat
rm -rf packetbeat-*

# Downloading the version to install
if [ ! -f "/vagrant/$PACKETBEAT_VERSION.tar.gz" ]; then
    wget -q https://download.elastic.co/beats/packetbeat/${PACKETBEAT_VERSION}.tar.gz
    tar -zxf $PACKETBEAT_VERSION.tar.gz
    rm -rf $PACKETBEAT_VERSION.tar.gz
else
    tar -zxf /vagrant/$PACKETBEAT_VERSION.tar.gz
fi

# Renaming extracted folder to a generic name to avoid changing commands 
mv $PACKETBEAT_VERSION packetbeat

chown -R vagrant: packetbeat

firewall-cmd --zone=public --add-port=5403/tcp --permanent
firewall-cmd --zone=public --add-port=5403/udp --permanent
systemctl stop firewalld
systemctl start firewalld

#allows packetbeat to capture as non-root user
setcap cap_net_raw=ep /home/vagrant/packetbeat/packetbeat

#let vagrant read the log folder - !BUG! needs better solution
chmod 755 /var/log -R
chmod 744 /var/log/* 
chmod 744 /var/log/audit/*
chmod 744 /var/log/anaconda/*  
chmod 744 /var/log/tuned/*  
