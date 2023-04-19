#!/bin/bash

# Install Certbot
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx

# Check for existing certificate
if ! sudo certbot certificates | grep -q 'No certificates found'; then
  echo "Les certificats existent déjà."
else
  # Obtain certificate
  sudo certbot --nginx -d "{{ sous_domaine_wordpress }}" -d "{{ sous_domaine_www_wordpress }}" -d "{{ sous_domaine_git }}" -d "{{ sous_domaine_www_git }}" -d "{{ sous_domaine_grafana }}" -d "{{ sous_domaine_www_grafana }}" -d "{{ sous_domaine_prometheus }}" -d "{{ sous_domaine_www_prometheus }}"
fi
