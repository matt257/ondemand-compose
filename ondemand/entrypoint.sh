#!/bin/bash

# Start httpd in the foreground
echo "Starting Apache HTTP server..."
/usr/sbin/httpd -k start

# Keep the container running
echo "Container is now running. Press Ctrl+C to stop."
tail -f /var/log/httpd/access_log /var/log/httpd/error_log
