<?php

/*
 * WARNING
 *
 * This file gets modified by automatic processes and all lines that are not
 * active code (ie. comments) are lost during that process.
 *
 * If you want to document things with comments or use constants add your settings
 * in a '<NAME>.config.php' file which will be included and rendered into this file.
 *
 * Example:
 *   <?php
 *   $CONFIG = [];
 *
 * See also: https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#multiple-merged-configuration-files
 */
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 => 
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'upgrade.disable-web' => true,
  'passwordsalt' => '1Xh36DFIbJvE8P0o8/dGmfc+ntJ1lz',
  'secret' => 'RxHHOOecDsKLYCE3Xv0pt4UCfbBPQu9fVlL01gV5o5WRJt6C',
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => 'webmail.nexustech.com.br',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'mysql',
  'version' => '34.0.0.12',
  'overwrite.cli.url' => 'http://localhost',
  'instanceid' => 'ocihzzjotdsr',
  'dbname' => 'nextcloud',
  'dbhost' => 'nextcloud-db',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'nextcloud',
  'dbpassword' => 'nextcloud_pass',
  'allow_local_remote_servers' => true,
  'installed' => true,
);
