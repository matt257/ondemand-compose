FROM osixia/openldap:1.5.0

COPY bootstrap.ldif /container/service/slapd/assets/config/bootstrap/ldif/50-bootstrap.ldif
COPY startup.sh /container/service/slapd/assets/startup.sh

# Set permissions and make the script executable
RUN chmod +x /container/service/slapd/assets/startup.sh

# Set custom startup script
ENTRYPOINT ["/container/service/slapd/assets/startup.sh"]
CMD ["--copy-service"]
