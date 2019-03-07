SLURM Vagrant Cluster
=====================

A demo SLURM cluster running in Vagrant virtual machines.

# Usage

Build VM's

```
make setup
```

Start SLURM daemons inside VM's

```
make start
```
Test that it is working

```
make test
```

## Extras

Stop VM's that are running

```
make stop
```
(must be restarted with `vagrant up`, or by running `make setup` again)

Delete VM's

```
make remove
```

Clean out SLURM logs

```
make clean
```

# Software

Tested with:

- Vagrant 2.0.1

- SLURM 15.08.7 (Ubuntu 16.04)

---
Fork from http://mussolblog.wordpress.com/

http://mussolblog.wordpress.com/2013/07/17/setting-up-a-testing-slurm-cluster/
