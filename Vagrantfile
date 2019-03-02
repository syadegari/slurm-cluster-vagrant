# -*- mode: ruby -*-
# vi: set ft=ruby :
#Define the list of machines
slurm_cluster = {
    :controller => {
        :hostname => "controller",
        :ipaddress => "10.10.10.3"
    },
    :server => {
        :hostname => "server",
        :ipaddress => "10.10.10.4"
    }
}

#Provisioning inline script
$script = <<SCRIPT
apt-get update
apt-get install -y -q vim slurm-llnl
echo "10.10.10.3    controller" >> /etc/hosts
echo "10.10.10.4    server" >> /etc/hosts
wget https://raw.githubusercontent.com/stevekm/slurm-cluster-vagrant/master/slurm.conf
mv slurm.conf /etc/slurm-llnl/
SCRIPT

Vagrant.configure("2") do |global_config|
    slurm_cluster.each_pair do |name, options|
        global_config.vm.define name do |config|
            #VM configurations
            config.vm.box = "ubuntu/xenial64"
            config.vm.network :private_network, ip: options[:ipaddress]

            #VM specifications
            config.vm.provider :virtualbox do |v|
                v.customize ["modifyvm", :id, "--memory", "1024"]
            end

            #VM provisioning
            config.vm.provision :shell,
                :inline => $script
        end
    end
end
