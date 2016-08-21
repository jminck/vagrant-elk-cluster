yum -q -y install screen

# Setting ES version to install
METRICBEAT_VERSION="metricbeat-5.0.0-alpha5-linux-x86_64"

# Removing all previous potentially installed version
rm -rf metricbeat
rm -rf metricbeat-*

# Downloading the version to install
if [ ! -f "/vagrant/$METRICBEAT_VERSION.tar.gz" ]; then
    wget -q https://download.elastic.co/beats/metricbeat/${METRICBEAT_VERSION}.tar.gz
    tar -zxf $METRICBEAT_VERSION.tar.gz
    rm -rf $METRICBEAT_VERSION.tar.gz
else
    tar -zxf /vagrant/$METRICBEAT_VERSION.tar.gz
fi

# Renaming extracted folder to a generic name to avoid changing commands 
mv $METRICBEAT_VERSION metricbeat

chown -R vagrant: metricbeat

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
