# slurm-compute-node-1

FROM ubuntu:20.04

# Set the environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    slurmd \
    munge \
    openssh-server \
    sudo \
    rsyslog

# Copy the munge.key file into the container
COPY munge.key /etc/munge/munge.key

# Configure munge and ensure correct ownership and permissions
RUN chown munge:munge /etc/munge/munge.key && chmod 400 /etc/munge/munge.key \
    && mkdir -p /var/log/munge /var/run/munge /var/lib/munge \
    && chown -R munge:munge /var/log/munge /var/run/munge /var/lib/munge

# Configure SLURM
COPY slurm.conf /etc/slurm-llnl/slurm.conf
COPY cgroup.conf /etc/slurm-llnl/cgroup.conf
RUN mkdir -p /var/spool/slurmd /var/log/slurm && chown slurm:slurm /var/spool/slurmd /var/log/slurm

# Add hpc.user with sudo privileges and set password
RUN useradd -m hpc.user && \
    echo 'hpc.user:password' | chpasswd && \
    usermod -aG sudo hpc.user

# Setup SSH server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Expose SSH and SLURM ports
EXPOSE 22 6817 6818 6819

# Copy the startup script
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Set the default command to run the startup script
ENTRYPOINT ["/usr/local/bin/startup.sh"]