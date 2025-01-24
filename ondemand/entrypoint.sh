#!/bin/bash

# Start httpd
echo "Starting Apache HTTP server..."
/usr/sbin/httpd -k start

# Start ondemand-dex
ondemand-dex serve /etc/ood/dex/config.yaml

# Keep the container running
echo "Container is now running. Press Ctrl+C to stop."
tail -f /var/log/httpd/access_log /var/log/httpd/error_log
