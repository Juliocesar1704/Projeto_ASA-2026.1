<?php
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
  'passwordsalt' => '4dzkqxUxcQYWOLo5SVOqhliqA5gcug',
  'secret' => 'ag9ltL+SakAV66NKupnMVfP4Vmk2earR/GOt4+X0RCUuN0IC',
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => 'webmail.isp.local',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'mysql',
  'version' => '33.0.5.1',
  'overwrite.cli.url' => 'http://localhost',
  'instanceid' => 'ocrciwz2igzw',
  'dbname' => 'nextcloud',
  'dbhost' => 'nextcloud-db',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'nextcloud',
  'dbpassword' => 'nextcloud_pass',
  'installed' => true,
);
