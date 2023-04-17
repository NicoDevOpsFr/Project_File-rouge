#!/bin/bash

# Install Certbot
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx

# Check for existing certificate
if ! sudo certbot certificates | grep -q 'No certificates found'; then
  echo "Les certificats existent déja."
else
  # Obtain certificate
  sudo certbot --nginx -d example.com -d www.example.com
fi
