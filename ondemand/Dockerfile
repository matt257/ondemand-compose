# Stage 1: Compile Ruby using Ubuntu
FROM ubuntu:20.04 as ruby-builder

# Install dependencies for building Ruby
RUN apt-get update && \
    apt-get install -y curl gnupg gcc g++ make \
    libssl-dev libreadline-dev zlib1g-dev autoconf bison libyaml-dev \
    libncurses5-dev libffi-dev libgdbm-dev openssl && \
    rm -rf /var/lib/apt/lists/*

# Import GPG keys for RVM
RUN gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys \
    409B6B1796C275462A1703113804BB82D39DC0E3 \
    7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# Install RVM, Ruby 3.1.4, and clean up
RUN curl -sSL https://get.rvm.io | bash -s stable && \
    /bin/bash -l -c "rvm install 3.1.4 --with-openssl-dir=$HOME/.rvm/usr && rvm cleanup all" && \
    echo "source /usr/local/rvm/scripts/rvm" > /etc/profile.d/rvm.sh

# Stage 2: Set up the final image using Rocky Linux
FROM rockylinux/rockylinux:9

# Install system updates and essential packages
RUN dnf -y update && \
    dnf install -y epel-release && \
    dnf clean all

# Disable all modules and then enable Ruby 3.1
RUN dnf -y module reset ruby && \
    dnf -y module enable ruby:3.1

# Install Ruby, additional packages, and SLURM
RUN dnf -y install ruby wget which httpd nodejs gcc gcc-c++ nmap-ncat sudo slurm && \
    dnf -y module reset nodejs && \
    dnf -y module enable nodejs:18 && \
    dnf -y install nodejs

# Configure SLURM
COPY slurm.conf /etc/slurm-llnl/slurm.conf
COPY cgroup.conf /etc/slurm-llnl/cgroup.conf

# Create self-signed SSL certificate
RUN mkdir -p /etc/pki/tls/certs /etc/pki/tls/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/pki/tls/private/localhost.key \
    -out /etc/pki/tls/certs/localhost.crt \
    -subj "/C=US/ST=YourState/L=YourCity/O=YourOrganization/OU=YourDepartment/CN=localhost"

# Download and install OnDemand RPM
RUN curl -O https://yum.osc.edu/ondemand/3.1/ondemand-release-web-3.1-1.el9.noarch.rpm && \
    dnf -y install ./ondemand-release-web-3.1-1.el9.noarch.rpm && \
    dnf -y install ondemand ondemand-dex --nobest --skip-broken

# Copy the RVM installations from the builder stage
COPY --from=ruby-builder /usr/local/rvm /usr/local/rvm

# Configure system to use the RVM-managed Ruby by default
RUN echo "source /usr/local/rvm/scripts/rvm" >> /etc/profile.d/rvm.sh && \
    echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc

# Configure HTTPD to use SSL
RUN sed -i 's|SSLCertificateFile.*|SSLCertificateFile /etc/pki/tls/certs/localhost.crt|' /etc/httpd/conf.d/ssl.conf && \
    sed -i 's|SSLCertificateKeyFile.*|SSLCertificateKeyFile /etc/pki/tls/private/localhost.key|' /etc/httpd/conf.d/ssl.conf

# Install sudo in case it's not included in the base image
RUN dnf -y install sudo

# Create a new user 'hpc.user' and add it to the 'wheel' group for sudo privileges
RUN useradd -m hpc.user && \
    echo 'hpc.user:password' | chpasswd && \
    usermod -aG wheel hpc.user

# setup sudoers for apache
RUN echo -e 'Defaults:apache !requiretty, !authenticate \n\
Defaults:apache env_keep += "NGINX_STAGE_* OOD_*" \n\
apache ALL=(ALL) NOPASSWD: /opt/ood/nginx_stage/sbin/nginx_stage' >/etc/sudoers.d/ood

# Copy configuration files
COPY ./ood_portal.yml /etc/ood/config/ood_portal.yml
COPY ./slurm-controller.yml /etc/ood/config/clusters.d/slurm-controller.yml
COPY ./slurm-compute-node-1.yml /etc/ood/config/clusters.d/slurm-compute-node-1.yml

# Update OOD portal and NGINX stage
RUN /opt/ood/ood-portal-generator/sbin/update_ood_portal && \
    /opt/ood/nginx_stage/sbin/update_nginx_stage

# Configure httpd servername to be localhost and OIDCSSL validation to be off
RUN echo -e "ServerName localhost\n\
OIDCSSLValidateServer Off\n" >> /etc/httpd/conf/httpd.conf

# Add startup script and set permissions
ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

# Start OnDemand
CMD ["/startup.sh"]
