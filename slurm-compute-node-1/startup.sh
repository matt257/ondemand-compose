#!/bin/bash

# Ensure correct ownership and permissions before starting services
mkdir -p /run/munge /var/log/munge /var/run/munge /var/lib/munge
chown -R munge:munge /run/munge /var/log/munge /var/run/munge /var/lib/munge

# Set the correct permissions
chmod 0755 /run/munge
chmod 0700 /var/log/munge /var/run/munge /var/lib/munge

# Create empty directories and files for slurm
sudo mkdir -p /var/spool/slurm/ctld
sudo touch /var/spool/slurm/ctld/node_state
sudo touch /var/spool/slurm/ctld/job_state
sudo touch /var/spool/slurm/ctld/resv_state
sudo touch /var/spool/slurm/ctld/trigger_state
sudo chown -R slurm:slurm /var/spool/slurm

# Start Munge
runuser -u munge -- /usr/sbin/munged -f

# Start SSH server
service ssh start

# Start SLURM daemon
/usr/sbin/slurmd -N slurm-compute-node-1

# Keep the container running
tail -f /dev/null
