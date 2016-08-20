yum -q -y install screen

# Setting ES version to install
KIBANA_VERSION="kibana-4.5.1-linux-x64"
KIBANA_PLUGIN_INSTALL_CMD="kibana/bin/kibana plugin --install"
BEATS_DASHBOARD_VERSION="beats-dashboards-1.2.3"
# Removing all previous potentially installed version
rm -rf kibana
rm -rf kibana-*

# Downloading the version to install
if [ ! -f "/vagrant/$KIBANA_VERSION.tar.gz" ]; then
    wget -q https://download.elastic.co/kibana/kibana/${KIBANA_VERSION}.tar.gz
    tar -zxf $KIBANA_VERSION.tar.gz
    rm -rf $KIBANA_VERSION.tar.gz
else
    tar -zxf /vagrant/$KIBANA_VERSION.tar.gz
fi

# Renaming extracted folder to a generic name to avoid changing commands 
mv $KIBANA_VERSION kibana
${KIBANA_PLUGIN_INSTALL_CMD} elastic/sense
${KIBANA_PLUGIN_INSTALL_CMD} elasticsearch/marvel/latest

chown -R vagrant: kibana

#install Beats dashboards
curl -L -O http://download.elastic.co/beats/dashboards/${BEATS_DASHBOARD_VERSION}.zip
unzip ${BEATS_DASHBOARD_VERSION}.zip
cd ${BEATS_DASHBOARD_VERSION}
./load.sh -url http://10.1.1.11:9200

#install metricbeat dashboard (placed here by metricbeat install, not part of dashboard pack as metricbeat is in Alpha)
cd /home/vagrant/metricbeat/kibana/
./import_dashboards.sh  -url http://10.1.1.11:9200

firewall-cmd --zone=public --add-port=9200/tcp --permanent
firewall-cmd --zone=public --add-port=9300/tcp --permanent
firewall-cmd --zone=public --add-port=5601/tcp --permanent
systemctl stop firewalld
systemctl start firewalld
