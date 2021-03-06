Vagrant ELK (Elasticsearch + Logstash (+ Filebeat) + Kibana) Cluster
=============================

Forked from https://github.com/bhaskarvk/vagrant-elk-cluster<br />
Updated versions of products and added Filebeat forwarding

Create an ELK Stack with a single bash command in Vmware, Parallels, or VirtualBox :

```bash
vagrant up --no-parallel --provider <virtualbox|parallels|vmware_fusion|vmware_workstation>
```
<div style='color:red'>**Read Pre Requisites below.**</div>**I would also highly recommend that you read this file in its entirety at least once.**<br/><br/>

---


**Software versions information**

| Software              | Version     | Description                        |
| --------------------------------- | ----------- | ----------------------------------------- |
| CentOS|7.1| Guest OS <br/> VMWare and Virtual box :[chef/centos-7.1](https://atlas.hashicorp.com/chef/boxes/centos-7.1) <br/> & parallels : [parallels/centos-7.1](https://atlas.hashicorp.com/parallels/boxes/centos-7.1) |
| Java (oracle)              | 1.8.0_91    |    [Download JDK](http://www.oracle.com/technetwork/java/javase/downloads/) |
| ElasticSearch                     | 2.3.3       | [Reference Guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html) / [Definitive Guide](https://www.elastic.co/guide/en/elasticsearch/guide/current/index.html) |
| Kibana | 4.5.1 | [Reference Guide](https://www.elastic.co/guide/en/kibana/current/index.html)|
| LogStash | 2.3.2 | [Reference Guide](https://www.elastic.co/guide/en/logstash/current/index.html)|
| Beats | 1.2.3 | [Reference Guide](https://www.elastic.co/guide/index.html)|

| All software requirements | ALL | Get same version of all requirements used by this project from my archive [here] (https://goo.gl/h7jpEs) |


**Cluster Details**

_Default Cluster Name_ : **es-dev-cluster**

_Default Network Setup_: **Private Network 10.1.1.0/24**

_Default CPU Cores Per Node_ : **1**

_Default RAM Per Node_ : **1024MB**

_ES Endpoint URL_ : [**http://localhost:9200/**](http://localhost:9200/) (_from Host Machine_)

_Kibana Endpoint URL_ : [**http://localhost:5601/**](http://localhost:5601/) (_from Host Machine_)

_Logstash Syslog Ports_ : **localhost:5514 (Both TCP and UDP)** (_from Host Machine_)

_Logstash Filebeat Port_ : ** 5510 (TCP)** ( Port used by Logstash to listen for Filebeat log forwards)

_Cluster Nodes :_


| VM Name| Node Name|Default IP| VM Port <=> Host Port|Description|
| -------|----------|----------|----------------------|-----------|
|vm1|thor|10.1.1.11|9200<=>9201<br/>9300<=>9301|1<sup>st</sup> Elasticsearch Node|
|vm2|zeus|10.1.1.12|9200<=>9202<br/>9300<=>9302|2<sup>nd</sup> Elasticsearch Node|
|vm3|isis|10.1.1.13|9200<=>9203<br/>9300<=>9303|3<sup>rd</sup> Elasticsearch Node|
|vm4|baal|10.1.1.14|9200<=>9204<br/>9300<=>9304|4<sup>th</sup> Elasticsearch Node<br/>(_Not started by default_)|
|vm5|shifu|10.1.1.15|9200<=>9205<br/>9300<=>9305|5<sup>th</sup> Elasticsearch Node<br/>(_Not started by default_)|
|vm250|kibana|10.1.1.250|**9200<=>9200<br/>9300<=>9300<br/>5601<=>5601**|Kibana + ES Client Node|
|vm251|logstash|10.1.1.251|**5514<=>5514<br/>(TCP & UDP)**|Logstash Node|


**WARNING**:  You'll need enough RAM to run VMs in your cluster. Each new VM launched within your cluster will have 1024M of RAM allocated.


**Elasticsearch Plugins**


| Plugin              | Version     | URL To Access                        |
| --------------------------------- | ----------- | ----------------------------------------- |
| [elasticsearch-mapper-attachments](https://github.com/elasticsearch/elasticsearch-mapper-attachments)  | 3.0.2      |  N.A. |
|[elasticsearch-head](https://github.com/mobz/elasticsearch-head)| latest| [http://localhost:9200/\_plugin/head/](http://localhost:9200/_plugin/head/)<br/>__NOT WORKING IN ES 2.0__ |
|[elasticsearch-kopf](https://github.com/lmenezes/elasticsearch-kopf)| 2.0.0| [http://localhost:9200/\_plugin/kopf](http://localhost:9200/_plugin/kopf) |
|[elasticsearch-paramedic](https://github.com/karmi/elasticsearch-paramedic)|latest | [http://localhost:9200/\_plugin/paramedic/](http://localhost:9200/_plugin/paramedic/)<br/>__NOT WORKING IN ES 2.0__|
|[elasticsearch-HQ](https://github.com/royrusso/elasticsearch-HQ) | latest| [http://localhost:9200/\_plugin/HQ/](http://localhost:9200/_plugin/HQ/)<br/>__NOT WORKING IN ES 2.0__|
|[bigdesk](https://github.com/lukas-vlcek/bigdesk)|latest|[http://localhost:9200/\_plugin/bigdesk](http://localhost:9200/_plugin/bigdesk)<br/>__NOT WORKING IN ES 2.0__ |
|[Sense](https://www.elastic.co/guide/en/sense/current/index.html)|2.0.0|[http://localhost:5601/app/sense](http://localhost:5601/app/sense)|
|[Marvel](https://www.elastic.co/guide/en/marvel/current/index.html)|2.3|[http://localhost:5601/app/marvel](http://localhost:5601/app/marvel)|

<br/>

---



1. Prerequisite & Set up
--

**Must have on your host machine**

* VirtualBox (last version) OR VMWare desktop|fusion OR parallels
* Vagrant (>=1.7)
* Respective vagrant plugins for vmware or parallels
* cUrl (or another REST client to talk to ES)

***Enable Vagrant reload provisioner plugin***  
`vagrant plugin install vagrant-reload`

**Clone this repository**

`git clone https://github.com/jminck/vagrant-elk-cluster.git`

**Download Installation Files**

This needs to be done just once.

*	Download JDK 8u65 64bit RPM from [Oracle](http://www.oracle.com/technetwork/java/javase/downloads/) 
*	Download elasticsearch-2.1.0.tar.gz from [elastic](https://www.elastic.co/downloads/elasticsearch)
*	Download kibana-4.3.0-linux-x64.tar.gz from [elastic](https://www.elastic.co/downloads/kibana)
*	Download logstash-2.1.0.tar.gz from [elastic](https://www.elastic.co/downloads/logstash)
*	Download packetbeat-1.2.3-x86_64.tar.gz from [elastic](https://download.elastic.co/beats/packetbeat/packetbeat-1.2.3-x86_64.tar.gz)
*	Download filebeat-1.2.3-x86_64.tar.gz from [elastic](https://download.elastic.co/beats/filebeat/filebeat-1.2.3-x86_64.tar.gz)
*	Download topbeat-1.2.3-x86_64.tar.gz from [elastic](https://download.elastic.co/beats/filebeat/topbeat-1.2.3-x86_64.tar.gz)
*	Download metricbeat-5.0.0-alpha5-linux-x86_64.tar.gz from [elastic](https://download.elastic.co/beats/metricbeat/metricbeat-5.0.0-alpha5-linux-x86_64.tar.gz)
*	Be lazy and get correct versions of all requirements used by this project from my archive [here] (https://goo.gl/h7jpEs) 
*	Place all the above files at the root of this repo.

Optional - update grok patterns for logstash

*   Download grok-patterns from [github] https://raw.githubusercontent.com/elastic/logstash/v1.2.2/patterns/grok-patterns
*   Place in conf/ subfolder of the project 


If you need to upgrade any of the above, download respective version and change the version number in `lib/upgrade-es.sh` OR  `lib/upgrade-kibana.sh` Or  `lib/upgrade-logstash.sh` accordingly and re-run provisioning.


2. How to run a new ELK Stack cluster
--

**Run the cluster**

Simply go in the cloned directory (vagrant-elk-cluster by default).
Execute this command :

```bash
vagrant up --no-parallel --provider <virtualbox|parallels|vmware_fusion|vmware_workstation>
```

 I recommend starting in `no-parallel` mode as it is the safest, but you can also try with removing this argument.

By default 3 ElasticSearch Nodes are started: vm1, vm2, and vm3. One kibana (vm250) and one logstash (vm251) node are also started.
You can start a maximum of 5 Elasticsearch nodes. If you want you can increase this limit by changing the code but it is pointless to have a bigger cluster for dev|qa purposes.

You can change the cluster size with the `CLUSTER_COUNT` variable (min 1 and max 5):

```bash
CLUSTER_COUNT=5 vagrant up 
```

You can change the cluster name with the `CLUSTER_NAME` variable:

```bash
CLUSTER_NAME='es-qa-cluster' vagrant up
```

You can change the cluster RAM used for each node with the `CLUSTER_RAM` variable:

```bash
CLUSTER_RAM=512 vagrant up
```

You can change the cluster CPU used for each node with the `CLUSTER_CPU` variable:

```bash
CLUSTER_CPU=2 vagrant up
```

You can change the cluster network IP address with the `CLUSTER_IP_PATTERN` variable:

```bash
CLUSTER_IP_PATTERN='172.16.15.%d' vagrant up
```

**NOTE** : Providing the `CLUSTER_NAME`, `CLUSTER_COUNT`, `CLUSTER_RAM`, `CLUSTER_CPU`, `CLUSTER_IP_PATTERN` variables is only required when you first start the cluster.
Vagrant will save/cache these values under the `.vagrant` directory, so you can run other commands without repeating yourself.

Of course you can use all these variables at the same time :

```bash
$ CLUSTER_NAME='es-qa-cluster' CLUSTER_IP_PATTERN='172.16.25.%d' CLUSTER_COUNT=5 \
CLUSTER_RAM=512 CLUSTER_CPU=2 vagrant up
```

**Sample output**

```
$ vagrant status
----------------------------------------------------------
          Your ES cluster configurations
----------------------------------------------------------
Cluster Name: dev-es-cluster
Cluster size: 3
Cluster network IP: 10.1.1.0
Cluster RAM (for each node): 1024
Cluster CPU (for each node): 1
----------------------------------------------------------
----------------------------------------------------------
Current machine states:

vm1                       stopped (parallels)
vm2                       stopped (parallels)
vm3                       stopped (parallels)
kibana                    stopped (parallels)
logstash                  stopped (parallels)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`....
```

The names of the Elasticsearch VMs will follow the following pattern: `vm[0-9]+`.
The trailing number represents the index of the VM, starting at 1. Kibana and Logstash instances are simply named kibana and logstash.

ElasticSearch, Kibana, & Logstash instances are started during provisioning of respective VMs.
The command is launched into a new screen as root user inside the vagrant.


**Stop the cluster**

```bash
vagrant halt
```

This will stop the whole cluster. If you want to only stop one VM, you can use:

```bash
vagrant halt vm2
```

This will stop the `vm2` instance.

**Destroy the cluster**

```bash
vagrant destroy
rm -rf .vagrant conf/*.yml conf/*.conf logs/* data/* 
```

This will stop the whole cluster. If you want to only stop one VM, you can use:

```bash
vagrant destroy vm2
```

:warning: If you destroy a VM, I suggest you to destroy all the cluster to be sure to have the same ES version in all of your nodes.

**Managing ElasticSearch instances**

Each VM has its own ElasticSearch instance running in a `screen` session named `elastic`.
Once connected to the VM, you can manage this instance with the following commands:

* `sudo node-start`: starts the ES instance
* `sudo node-stop`: stops the ES instance
* `sudo node-restart`: restarts the ES instance
* `sudo node-status`: displays ES instance's status
* `sudo node-attach`: bring you to the screen session hosting the ES instance. Use `^Ad` to detach.

You should be brought to the screen session hosting ElasticSearch and see its log.

For Kibana use `sudo kibana-<start|stop|restart|status|attach>`, and similarly for Logstash use `sudo logstash-<start|stop|restart|status|attach>`


**Default Directories**

By default the `data`, `logs` and `config` directories live outside of the VMs on the host, this way you can destroy and rebuild VMs as much as you like without losing your data. You can also upgrade Elasticsearch and not lose data.

3. Access the Cluster
--

The 9200 and 9300 ports of the host machine have been setup to forward to respective ports of ES Client Node running on Kibana.
To access ES Rest API from Host machine you can use [**http://localhost:9200/**](http://localhost:9200/) which will route the API Access via the Client Node running on the Kibana Node.

TO access ES Rest Endpoint on a data node, use 9200 + \<node number> on the host machine. so for vm1 it would be  9201 so [http://localhost:9201/](http://localhost:9201/) and 9202 for vm2, and so forth. But you will hardly need to access these endpoints from host machine.

To access Kibana from host machine use [**http://localhost:5601/**](http://localhost:5601/). Logstash node has been setup to receive syslog messages on port 5514 (TCP & UDP) and the host machine will forward anything on its port 5514 (TCP & UDP) to these ports.

4. Configure your cluster
--

If you need or want to change the default working configuration of your cluster,
you can do it adding/editing elasticsearch-<VM-Name>.yml files in `conf` directory.
Each node configuration is shared with VM thanks to this "conf" directory.

By default, this configuration files are **auto-generated** by Vagrant when running the cluster for the first time.
In this case, default values listed at the top of this page are used.

Similarly for logstash you need to change conf/logstash-<VM Name>.conf file again in `conf` directory.


5. Working with your cluster
--

Here are a few sample calls to get you started.

Send some sample syslog messages to Logstash to be indexed in Elasticsearch.

```bash
# From the host machine
# I'm assuming the host is some sort of UNIX box
# If windows, then you are on your own :)
echo "<133>$0[$$]: Test syslog message from Netcat" | nc -4 localhost 5514
echo "<133>$0[$$]: Second Test syslog message from Netcat" | nc -4 localhost 5514
```

Next go to Kibana Dashboard at [http://localhost:5601/](http://localhost:5601/). Kibana will auto discover the logstash index and ask you some basic question, just select the default, and then go to the discover tab. You should see the two sample messages.

---

6. Validation of first time setup
--

- Launch Kibana [**http://localhost:5601/**](http://localhost:5601/)
- If things are working as expected, logs from /var/log on all machines in the environment should be forwarding via filebeat to logstash over tcp 5510, and they should be output into elasticsearch, so you should immediately see events in Kibana

**If you don't see data in Kibana**
- go to settings and create an index pattern (take defaults and just ckick "create" button)
- review elasticsearch basic health if Kibana isn't loading
 - `curl -XGET http://localhost:9200/_cluster/health?pretty`
   - Status should be GREEN  
 - `curl -XGET http://localhost:9200/_cat/shards`
   - There should be no unassigned shards 
    - if .kibana shards are unassigned run `curl -XDELETE http://localhost:9200/.kibana` and then restart kibana machine with `vagrant reload kibana`
    - More tricks in [cat api] (https://www.elastic.co/guide/en/elasticsearch/reference/current/cat.html)

**Other useful things to know**
- /vagrant/scripts contains start, stop, restart scripts for kibana, logstash, filebeat and elasticsearch, use these to start/stop services because this is how Vagrant does it (and it uses the screen utility to launch processes in the background).
- the proper way to restart ANY of the machines is by using `vagrant reload` so that things are started and the folder redirection that mounts /vagrant within the VM to the root of the folder you're running in on the host.


7. Import a sample dataset and visualize it
--
In the sampledata/nyc_collision folder, there are some files taken from: 
https://github.com/elastic/examples/tree/master/ELK_nyc_traffic_accidents.<br />
For more information about this section, see the source repo's README [ here](https://github.com/elastic/examples/blob/master/ELK_nyc_traffic_accidents/README.md).

1) Import data with logstash

* Run the script `import_nyc_crash_data` from the logstash vm.

  run `vagrant ssh logstash`
  
  once logged into the logstash vm run the following:
  
  `cd /vagrant/sampledata/nyc_collision` <br />
  `./import_nyc_crash_data`
  

* This will download  nyc_collision_data.csv from [NYC Open Data Portal](https://data.cityofnewyork.us/Public-Safety/NYPD-Motor-Vehicle-Collisions/h9gi-nx95?).
* it will also import the CSV into elasticsearch. Only the file nyc_collision_logstash.conf has been modified, it points to http://10.1.1.11:9200 (vm1) instead of localhost in its output stanza.

2)  Visualize data in Kibana

* Access Kibana by going to `http://localhost:5601` in a web browser from your host machine
* Connect Kibana to the `nyc_visionzero` index in Elasticsearch (autocreated in step 1)
    * Click the **Settings** tab >> **Indices** tab >> **Create New**. Specify `nyc_visionzero` as the index pattern name and click **Create** to define the index pattern. (Leave the **Use event times to create index names** box unchecked)
* Load sample dashboard into Kibana
    * Click the **Settings** tab >> **Objects** tab >> **Import**, and select `nyc_collision_kibana.json`
* Open dashboard
    * Click on **Dashboard** tab and open `NYC Motor Vehicles Collision` dashboard

Voila! You should see the following dashboard. Happy Data Exploration!
![Kibana Dashboard Screenshot](https://cloud.githubusercontent.com/assets/5269751/10008565/f548dc28-6084-11e5-9956-b29c2ca043ee.png)

**TODO**

See issues.

