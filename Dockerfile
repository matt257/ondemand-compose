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

# Install Ruby and additional packages
RUN dnf -y install ruby wget which httpd nodejs gcc gcc-c++ && \
    dnf -y module reset nodejs && \
    dnf -y module enable nodejs:18 && \
    dnf -y install nodejs

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

# Reinstall Ruby to ensure proper integration with OpenSSL
RUN /bin/bash -l -c "rvm pkg install openssl && rvm reinstall ruby-3.1.4 --with-openssl-dir=$HOME/.rvm/usr"

# Command to start HTTP server
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
