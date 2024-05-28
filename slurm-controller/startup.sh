#!/bin/bash

# Start munge
service munge start

# Start SLURM control daemon
service slurmctld start

# Start SSH server
service ssh start

# Keep the container running
tail -f /dev/null
