#!/bin/bash
# Ensure we exit with an error on drush errors.
set -e

# Install script for in the docker container.
cd /var/www/html/;

# Set the correct settings.php requires scripts folder to be mounted in /var/www/scripts/social.
chmod 777 /var/www/html/sites/default

time drush -y site-install --db-url=mysql://root:root@db:3306/oec --account-pass=admin --site-name='OEC Group dev';
echo "installed OEC Group dev"

drush -y ucrt jaapjan --password=jaapjan
drush -y ucrt harry --password=harry

drush sql-dump > /var/www/sql-backups/clean-without-modules.sql
time drush -y en group
drush sql-dump > /var/www/sql-backups/clean-with-group.sql
time drush -y en group_flex
drush sql-dump > /var/www/sql-backups/clean.sql

#drush cdel field.field.node.article.body
#drush cdel field.field.node.page.body
#drush entity:delete shortcut_set
#drush -y cset system.site uuid "4665d630-8df0-40a5-94c9-0da72da4af0c"
#drush -y config:import
#echo "imported configuration"

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
