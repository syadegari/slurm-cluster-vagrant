# -*- mode: ruby -*-
# vi: set ft=ruby :
#Define the list of machines
slurm_cluster = {
    :controller => {
        :hostname => "controller",
        :ipaddress => "10.10.10.3"
    },
    :server1 => {
        :hostname => "server1",
        :ipaddress => "10.10.10.4"
    },
    :server2 => {
        :hostname => "server2",
        :ipaddress => "10.10.10.5"
    },
    :server3 => {
        :hostname => "server3",
        :ipaddress => "10.10.10.6"
    }
}

#Provisioning inline script
$script = <<SCRIPT

apt-get update
apt-get upgrade -y
apt-get -y install openmpi-common openmpi-bin libopenmpi-dev openmpi-doc


apt-get install -y -q vim slurm-wlm python3-pip
pip3 install mpi4py numpy 
ln -s /vagrant/slurm.conf /etc/slurm-llnl/slurm.conf
echo "10.10.10.3    controller" >> /etc/hosts
echo "10.10.10.4    server1"    >> /etc/hosts
echo "10.10.10.5    server2"    >> /etc/hosts
echo "10.10.10.6    server3"    >> /etc/hosts

SCRIPT

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |global_config|
    slurm_cluster.each_pair do |name, options|
        global_config.vm.define name do |config|
            #VM configurations
            config.vm.box = "ubuntu/focal64"
            config.vm.hostname = "#{name}"
            config.vm.network :private_network, ip: options[:ipaddress]

            #VM specifications
            config.vm.provider :virtualbox do |v|
                v.cpus = 2
                v.memory = 512
            end

            #VM provisioning
            config.vm.provision :shell,
                :inline => $script
        end
    end
end
