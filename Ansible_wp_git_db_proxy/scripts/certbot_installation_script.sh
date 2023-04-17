#!/bin/bash

# Install Certbot
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx

# Check for existing certificate
if ! sudo certbot certificates | grep -q 'No certificates found'; then
  echo "Certificate already exists"
else
  # Obtain certificate
  sudo certbot --nginx -d somily.fr -d www.somily.fr -d wordpress.somily.fr -d www.wordpress.somily.fr -d git.somily.fr -d www.git.somily.fr -d grafana.somily.fr -d www.grafana.somily.fr -d prometheus.somily.fr -d www.prometheus.somily.fr 
fi
