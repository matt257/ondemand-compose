# slurm-controller

FROM ubuntu:20.04

# Set the environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update the package repository and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    munge \
    libmunge-dev \
    libmunge2 \
    curl \
    wget \
    vim \
    python3 \
    python3-pip \
    sudo \
    openssh-server \
    slurm-wlm \
    mailutils

# Copy the munge.key file into the container
COPY munge.key /etc/munge/munge.key

# Set the correct ownership and permissions
RUN chown munge:munge /etc/munge/munge.key && chmod 400 /etc/munge/munge.key

# Create directories and set permissions
RUN mkdir -p /var/log/slurm /var/spool/slurm/ctld && \
    chown -R slurm:slurm /var/log/slurm /var/spool/slurm/ctld

# Add hpc.user with sudo privileges and set password
RUN useradd -m hpc.user && \
    echo 'hpc.user:password' | chpasswd && \
    usermod -aG sudo hpc.user
    
# Copy SLURM configuration files
COPY slurm.conf /etc/slurm-llnl/slurm.conf
COPY cgroup.conf /etc/slurm-llnl/cgroup.conf

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
CMD ["/usr/local/bin/startup.sh"]
