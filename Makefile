SHELL:=/bin/bash

# Create Vagrant VMs
# copy munge authenication key from controller to node
# !! need cp -p or else munge keys do not work
setup:
	vagrant up && \
	vagrant ssh controller -- -t 'sudo cp -p /etc/munge/munge.key /vagrant/' && \
	vagrant ssh server -- -t 'sudo cp -p /vagrant/munge.key /etc/munge/' && \
	vagrant ssh server -- -t 'sudo chown munge /etc/munge/munge.key' && \
	vagrant ssh controller -- -t 'ssh-keygen -b 2048 -t rsa -q -N "" -f /home/vagrant/.ssh/id_rsa' && \
	vagrant ssh controller -- -t 'cp /home/vagrant/.ssh/id_rsa.pub /vagrant/id_rsa.controller.pub' && \
	vagrant ssh server -- -t 'cat /vagrant/id_rsa.controller.pub >> .ssh/authorized_keys' && \
	vagrant ssh server -- -t 'ssh-keygen -b 2048 -t rsa -q -N "" -f /home/vagrant/.ssh/id_rsa' && \
	vagrant ssh server -- -t 'cp /home/vagrant/.ssh/id_rsa.pub /vagrant/id_rsa.server.pub' && \
	vagrant ssh controller -- -t 'cat /vagrant/id_rsa.server.pub >> .ssh/authorized_keys' && \
	rm -f munge.key id_rsa.controller.pub id_rsa.server.pub

# make sure 'slurm' dir is writable for VMs
# start munge in both VMs
# start slurmctld, wait many seconds for it to fully start
# start slurmd
start:
	find slurm -type d -exec chmod a+rwx {} \; && \
	vagrant ssh controller -- -t 'sudo /etc/init.d/munge start' && \
	vagrant ssh server -- -t 'sudo /etc/init.d/munge start' && \
	vagrant ssh controller -- -t 'sudo slurmctld; sleep 30' && \
	vagrant ssh server -- -t 'sudo slurmd'

# might need this to fix node down state
# sudo scontrol update nodename=server state=resume

# https://slurm.schedmd.com/troubleshoot.html
# munge log: /var/log/munge/munged.log
test:
	@echo ">>> Checking munge keys on both machines"
	@vagrant ssh controller -- -t 'sudo md5sum /etc/munge/munge.key; ls -l /etc/munge/munge.key'
	@vagrant ssh server -- -t 'sudo md5sum /etc/munge/munge.key; ls -l /etc/munge/munge.key'
	@echo ">>> Checking if controller can contact node (network)"
	@vagrant ssh controller -- -t 'ping 10.10.10.4 -c1'
	@echo ">>> Checking if SLURM controller is running"
	@vagrant ssh controller -- -t 'scontrol ping'
	@echo ">>> Checking if slurmctld is running on controller"
	@vagrant ssh controller -- -t 'ps -el | grep slurmctld'
	@echo ">>> Checking if node can contact controller (network)"
	@vagrant ssh server -- -t 'ping 10.10.10.3 -c1'
	@echo ">>> Checking if node can contact SLURM controller"
	@vagrant ssh server -- -t 'scontrol ping'
	@echo ">>> Checking if slurmd is running on node"
	@vagrant ssh server -- -t 'ps -el | grep slurmd'
	@echo ">>> Running a test job"
	@vagrant ssh controller -- -t 'sbatch --wrap="hostname"'
	@echo ">>> Running another test job"
	@vagrant ssh controller -- -t 'sbatch /vagrant/job.sh'
	@echo ">>> Checking node status"
	@vagrant ssh controller -- -t 'scontrol show nodes=server'

# pull the plug on the VMs
stop:
	vagrant halt --force controller
	vagrant halt --force server

# delete the VMs
remove:
	vagrant destroy controller
	vagrant destroy server

# location of the SLURM default config generators for making new conf files
get-config-html:
	vagrant ssh controller -- -t 'cp /usr/share/doc/slurmctld/*.html /vagrant/'

# get rid of the SLURM log files
clean:
	find slurm -type f ! -name ".gitkeep" -exec rm -f {} \;
