SHELL:=/bin/bash

setup:
	vagrant up && \
	vagrant ssh controller -- -t 'sudo cp -f /etc/munge/munge.key /vagrant/' && \
	vagrant ssh server -- -t 'sudo cp /vagrant/munge.key /etc/munge/' && \
	vagrant ssh server -- -t 'sudo chown munge /etc/munge/munge.key' && \
	rm -f munge.key

start:
	find slurm -type d -exec chmod a+rwx {} \; && \
	vagrant ssh controller -- -t 'sudo /etc/init.d/munge start' && \
	vagrant ssh server -- -t 'sudo /etc/init.d/munge start' && \
	vagrant ssh controller -- -t 'sudo slurmctld; sleep 5' && \
	vagrant ssh server -- -t 'sudo /etc/init.d/slurmd start'

# https://slurm.schedmd.com/troubleshoot.html
test:
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

stop:
	vagrant halt --force controller
	vagrant halt --force server

remove:
	vagrant destroy controller
	vagrant destroy server
# -L /vagrant/controller.log

get-config-html:
	vagrant ssh controller -- -t 'cp /usr/share/doc/slurmctld/*.html /vagrant/'

clean:
	find slurm -type f ! -name ".gitkeep" -exec rm -f {} \;
