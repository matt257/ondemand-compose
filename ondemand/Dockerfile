# Use the official Rocky Linux 9 image
FROM rockylinux:9

# Set a label for metadata
LABEL maintainer="matt257"

# Install necessary packages and enable modules
RUN dnf install -y dnf-plugins-core && \
    dnf config-manager --set-enabled crb && \
    dnf install -y epel-release && \
    dnf module enable ruby:3.3 nodejs:20 -y && \
    dnf clean all

# Install OnDemand and dependencies
RUN dnf install -y https://yum.osc.edu/ondemand/4.0/ondemand-release-web-4.0-1.el9.noarch.rpm && \
    dnf install -y ondemand ondemand-dex httpd procps && \
    dnf clean all

# Create self-signed SSL certificate
RUN mkdir -p /etc/pki/tls/certs /etc/pki/tls/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/pki/tls/private/localhost.key \
    -out /etc/pki/tls/certs/localhost.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"

# Update SSL configuration to use the generated self-signed certificate
RUN sed -i 's|^SSLCertificateFile .*|SSLCertificateFile /etc/pki/tls/certs/localhost.crt|' /etc/httpd/conf.d/ssl.conf && \
    sed -i 's|^SSLCertificateKeyFile .*|SSLCertificateKeyFile /etc/pki/tls/private/localhost.key|' /etc/httpd/conf.d/ssl.conf

# Configure Apache HTTP server to run in the foreground
RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

# Copy portal configuration
COPY ./ood_portal.yml /etc/ood/config/ood_portal.yml

# Add a simple entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the ports used by Apache HTTP server
EXPOSE 80 443 8080 5554 5556

# Use the entrypoint script to start the container
ENTRYPOINT ["/entrypoint.sh"]
