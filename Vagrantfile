# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'erb'
require_relative 'lib/elasticsearch-module.rb'
require_relative 'lib/elasticsearch-script.rb'
require_relative 'lib/kibana-script.rb'
require_relative 'lib/logstash-script.rb'
require_relative 'lib/filebeat-script.rb'
require_relative 'lib/topbeat-script.rb'
require_relative 'lib/metricbeat-script.rb'
require_relative 'lib/packetbeat-script.rb'

utils = Vagrant::ElastiSearchCluster::Util.new

Vagrant.configure("2") do |config|

    utils.manage_and_print_config

    nodes_number = utils.get_cluster_info 'cluster_count'
    nodes_number = nodes_number.to_i

    cluster_ram = utils.get_cluster_info 'cluster_ram'
    cluster_ram = cluster_ram.to_i

    cluster_cpu = utils.get_cluster_info 'cluster_cpu'
    cluster_cpu = cluster_cpu.to_i

    #config.vm.box = 'chef/centos-7.1'
    config.vm.box = 'bhaskarvk/centos7-x86_64'
    config.ssh.insert_key = false

    # Virtualbox
    config.vm.provider 'virtualbox' do |vbox, override|
        override.vm.synced_folder ".", "/vagrant", :id => "vagrant-root",
            :mount_options => ['dmode=777', 'fmode=777']
        vbox.customize ['modifyvm', :id, '--memory', cluster_ram]
        vbox.customize ['modifyvm', :id, '--cpus', cluster_cpu]
        vbox.gui = false
    end

    # Parallels
    config.vm.provider "parallels" do |v, override|
        override.vm.box = "parallels/centos-7.1"
        #v.update_guest_tools = true
        v.optimize_power_consumption = false
        v.memory = cluster_ram
        v.cpus = cluster_cpu
    end

    # VMWare
    ["vmware_fusion", "vmware_workstation"].each do |vmware|
        config.vm.provider vmware do |v|
            v.vmx["memsize"] = cluster_ram
            v.vmx["numvcpus"] = cluster_cpu
            v.gui = false
        end
    end


    # ES Nodes
    (1..nodes_number).each do |index|
        name = utils.get_vm_name index
        node_name = utils.get_node_name index
        ip = utils.get_vm_ip index
        primary = (index.eql? 1)

        utils.build_config index
        utils.build_filebeat_config name
        utils.build_topbeat_config name
        utils.build_metricbeat_config name
        utils.build_packetbeat_config name

        config.vm.define :"#{name}", primary: primary do |node|
            node.vm.hostname = "#{name}.es.dev"
            node.vm.network 'private_network', ip: ip, auto_config: true
            node.vm.provision 'shell', path: './lib/upgrade-es.sh'
            node.vm.provision 'shell', inline: @node_start_inline_script % [name, node_name, ip],
                run: 'always'
            node.vm.provision 'shell', path: './lib/upgrade-filebeat.sh'
            node.vm.provision 'shell', inline: @filebeat_start_inline_script % [name, node_name, ip],
                run: 'always'
            node.vm.provision 'shell', path: './lib/upgrade-topbeat.sh'
            node.vm.provision 'shell', inline: @topbeat_start_inline_script % [name, node_name, ip],
                run: 'always'
            node.vm.provision 'shell', path: './lib/upgrade-packetbeat.sh'
            node.vm.provision 'shell', inline: @packetbeat_start_inline_script % [name, node_name, ip],
                run: 'always'
            node.vm.provision 'shell', path: './lib/upgrade-metricbeat.sh'
            node.vm.provision 'shell', inline: @metricbeat_start_inline_script % [name, node_name, ip],
                run: 'always'
            #This is to workaround unreliable static IP addignment due to BOOTPROTO=none instead of static set by Vagrant
            node.vm.provision 'shell', inline: "sudo sed -i 's/BOOTPROTO=none/BOOTPROTO=static/g' /etc/sysconfig/network-scripts/ifcfg-*",
                run: 'always'
            node.vm.network "forwarded_port", guest: 9200, host: 9200+index
            node.vm.network "forwarded_port", guest: 9300, host: 9300+index
            node.vm.provision :reload
            node.vm.provider "parallels" do |v|
                v.name = "elasticsearch-#{name}"
            end
            node.vm.provider "virtualbox" do |v|
                v.name = "elasticsearch-#{name}"
            end
            ["vmware_fusion", "vmware_workstation"].each do |vmware|
                node.vm.provider vmware do |v|
                    v.vmx["displayname"] =  "elasticsearch-#{name}"
                end
            end
        end
    end

    # logstash
    config.vm.define :"logstash" do |node|
        name = utils.get_logstash_vm_name
        node_name = utils.get_logstash_node_name
        ip = utils.get_logstash_vm_ip
        utils.build_logstash_config
        utils.build_filebeat_config name
        utils.build_topbeat_config name
        utils.build_metricbeat_config name
        utils.build_packetbeat_config name

        node.vm.hostname = "#{node_name}.es.dev"
        node.vm.network 'private_network', ip: ip, auto_config: true
        node.vm.provision 'shell', path: './lib/upgrade-logstash.sh'
        node.vm.provision 'shell', inline: @logstash_start_inline_script % [name, node_name, ip],
            run: 'always'
        node.vm.provision 'shell', path: './lib/upgrade-filebeat.sh'
        node.vm.provision 'shell', inline: @filebeat_start_inline_script % [name, node_name, ip],
            run: 'always'
        node.vm.provision 'shell', path: './lib/upgrade-topbeat.sh'
        node.vm.provision 'shell', inline: @topbeat_start_inline_script % [name, node_name, ip],
            run: 'always'
        node.vm.provision 'shell', path: './lib/upgrade-packetbeat.sh'
        node.vm.provision 'shell', inline: @packetbeat_start_inline_script % [name, node_name, ip],
            run: 'always'
        node.vm.provision 'shell', path: './lib/upgrade-metricbeat.sh'
        node.vm.provision 'shell', inline: @metricbeat_start_inline_script % [name, node_name, ip],
            run: 'always'
        #This is to workaround unreliable static IP addignment due to BOOTPROTO=none instead of static set by Vagrant
        node.vm.provision 'shell', inline: "sudo sed -i 's/BOOTPROTO=none/BOOTPROTO=static/g' /etc/sysconfig/network-scripts/ifcfg-*",
            run: 'always'
        node.vm.network "forwarded_port", guest: 5514, host: 5514, protocol: 'tcp'
        node.vm.network "forwarded_port", guest: 5514, host: 5514, protocol: 'udp'
        node.vm.provision :reload
        node.vm.provider "parallels" do |v|
            v.name = "elasticsearch-#{name}"
        end
        node.vm.provider "virtualbox" do |v|
            v.name = "elasticsearch-#{name}"
        end
        ["vmware_fusion", "vmware_workstation"].each do |vmware|
            node.vm.provider vmware do |v|
                v.vmx["displayname"] =  "elasticsearch-#{name}"
            end
        end
    end

    # Kibana + Client Node
    config.vm.define :"kibana" do |node|
        name = utils.get_kibana_vm_name
        node_name = utils.get_kibana_node_name
        ip = utils.get_kibana_vm_ip
        utils.build_kibana_config
        utils.build_filebeat_config name
        utils.build_topbeat_config name
        utils.build_metricbeat_config name
        utils.build_packetbeat_config name

        node.vm.hostname = "#{node_name}.es.dev"
        node.vm.network 'private_network', ip: ip, auto_config: true
        node.vm.provision 'shell', path: './lib/upgrade-filebeat.sh'
        node.vm.provision 'shell', inline: @filebeat_start_inline_script % [name, node_name, ip],
            run: 'always'
        node.vm.provision 'shell', path: './lib/upgrade-topbeat.sh'
        node.vm.provision 'shell', inline: @topbeat_start_inline_script % [name, node_name, ip],
            run: 'always'
        node.vm.provision 'shell', path: './lib/upgrade-metricbeat.sh'
        node.vm.provision 'shell', inline: @metricbeat_start_inline_script % [name, node_name, ip],
            run: 'always'
        node.vm.provision 'shell', path: './lib/upgrade-packetbeat.sh'
        node.vm.provision 'shell', inline: @packetbeat_start_inline_script % [name, node_name, ip],
            run: 'always'
        node.vm.provision 'shell', path: './lib/upgrade-es.sh'
        node.vm.provision 'shell', inline: @node_start_inline_script % [name, node_name, ip],
            run: 'always'
        node.vm.provision 'shell', path: './lib/upgrade-kibana.sh'
        node.vm.provision 'shell', inline: @kibana_start_inline_script % [name, node_name, ip],
            run: 'always'
        #This is to workaround unreliable static IP addignment due to BOOTPROTO=none instead of static set by Vagrant
        node.vm.provision 'shell', inline: "sudo sed -i 's/BOOTPROTO=none/BOOTPROTO=static/g' /etc/sysconfig/network-scripts/ifcfg-*",
            run: 'always'
        node.vm.network "forwarded_port", guest: 9200, host: 9200
        node.vm.network "forwarded_port", guest: 9300, host: 9300
        node.vm.network "forwarded_port", guest: 5601, host: 5601
        node.vm.provision :reload
        node.vm.provider "parallels" do |v|
            v.name = "elasticsearch-#{name}"
        end
        node.vm.provider "virtualbox" do |v|
            v.name = "elasticsearch-#{name}"
        end
        ["vmware_fusion", "vmware_workstation"].each do |vmware|
            node.vm.provider vmware do |v|
                v.vmx["displayname"] =  "elasticsearch-#{name}"
            end
        end
    end

    # Windows 2012 R2 client
         config.vm.define :"winclient" do |winclient|
             winclient.vm.box = "mwrock/Windows2012R2" 
             name = "Winclient"
             winclient_name = name
             ip = "10.1.1.252"
             winclient.vm.synced_folder "./", "/vagrant"
             winclient.vm.hostname = "#{winclient_name}"
             winclient.vm.network 'private_network', ip: ip, auto_config: true
             winclient.vm.provision "shell", path: "lib/win-client.ps1", privileged: true, powershell_elevated_interactive: true
             winclient.vm.provider "virtualbox" do |v|
                 v.name = name
             end
         end

    utils.logger.info "----------------------------------------------------------"
end
