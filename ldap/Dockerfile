# Use osixia/openldap as the base image
FROM osixia/openldap:latest

# Set environment variables
ENV LDAP_LOG_LEVEL=256 \
    LDAP_ORGANISATION="local host" \
    LDAP_DOMAIN=ldap.localhost \
    LDAP_ADMIN_PASSWORD=admin \
    LDAP_TLS_VERIFY_CLIENT=never

# Copy the startup file
COPY ./startup.ldif /container/service/slapd/assets/config/bootstrap/ldif/50-bootstrap.ldif

# Expose ports for LDAP and LDAPS
EXPOSE 389 636

# Set the default command to run when starting the container
CMD ["--copy-service"]
