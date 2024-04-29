# Use the official OpenLDAP image
FROM osixia/openldap:1.5.0

# Set environment variables for OpenLDAP
ENV LDAP_ORGANISATION="Example Inc."
ENV LDAP_DOMAIN="example.org"
ENV LDAP_ADMIN_PASSWORD="admin"

# Copy the LDIF file to the container
COPY ./startup.ldif /container/service/slapd/assets/config/bootstrap/ldif/50-bootstrap.ldif

# Expose the default LDAP port
EXPOSE 389
