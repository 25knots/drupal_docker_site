#!/bin/bash
# Ensure we exit with an error on drush errors.
set -e

# Install script for in the docker container.
cd /var/www/html/;

# Set the correct settings.php requires scripts folder to be mounted in /var/www/scripts/social.
chmod 777 /var/www/html/sites/default

time drush -y site-install --db-url=mysql://root:root@db:3306/dds --account-pass=admin --site-name='DDS';
echo "installed DDS"

php -r 'opcache_reset();';
echo "opcache reset"

time drush -y cr
echo "cache clear"

# Create private files directory.
if [ ! -d /var/www/files_private ]; then
  mkdir /var/www/files_private;
else
  # Empty existing directory
  rm -rf /var/www/files_private/*
fi
# Change permissions
chmod 444 sites/default/settings.php
chmod 777 -R /var/www/files_private;
chmod 777 -R sites/default/files
