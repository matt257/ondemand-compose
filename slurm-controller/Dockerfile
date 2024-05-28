# Use an official Ubuntu as a parent image
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
    slurm-wlm

# Create munge key directory and generate key
RUN /usr/sbin/create-munge-key

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

# Expose SSH port
EXPOSE 22

# Expose SLURM ports
EXPOSE 6817 6818 6819

# Copy the startup script
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Set the default command to run the startup script
CMD ["/usr/local/bin/startup.sh"]
