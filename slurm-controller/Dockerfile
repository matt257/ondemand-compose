# Use a base image with SLURM installed
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y slurm-wlm munge

# Set up Munge
RUN apt-get install -y munge libmunge-dev
RUN /usr/sbin/create-munge-key
RUN chown -R munge: /etc/munge
RUN chmod 0700 /etc/munge

# Copy SLURM configuration files
COPY slurm.conf /etc/slurm-llnl/slurm.conf
COPY cgroup.conf /etc/slurm-llnl/cgroup.conf

# Set up environment variables
ENV SLURM_USER=slurm \
    MUNGE_USER=munge

# Create the log directory and set permissions
RUN mkdir -p /var/log/slurm && \
    chown slurm:slurm /var/log/slurm

# Start Munge and SLURM services
CMD service munge start && \
    service slurmctld start && \
    tail -f /var/log/slurm/slurmctld.log
