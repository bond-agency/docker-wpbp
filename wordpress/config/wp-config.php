<?php
/**
 * Set a global variable that you can use in your theme & plugins to check the
 * current environment. This must be defined in all environments though.
 */

define( 'WPTB_ENV', getenv( 'WPTB_ENV' ) );

if( ! defined( 'WPTB_ENV' ) ) {
  //define( 'WPTB_ENV', 'development' );
  //define( 'WPTB_ENV', 'staging' );
  define( 'WPTB_ENV', 'production' );
}

define( 'DISALLOW_FILE_EDIT', true );
define( 'WP_MEMORY_LIMIT', '128M' );
define( 'WP_MAX_MEMORY_LIMIT', '256M' );
define( 'WP_POST_REVISIONS', 5 );
define( 'RT_WP_NGINX_HELPER_CACHE_PATH', '/var/www/cache' );

if ( constant( 'WPTB_ENV' ) === 'development' ) {
  define( 'WP_DEBUG', true );
  define( 'WP_DEBUG_LOG', true );
  define( 'WP_DEBUG_DISPLAY', true );
} elseif (constant( 'WPTB_ENV' ) === 'staging' ) {
  define( 'WP_DEBUG', true );
  define( 'WP_DEBUG_LOG', true );
  define( 'WP_DEBUG_DISPLAY', true );
} else {
  define( 'WP_DEBUG', false );
  define( 'WP_DEBUG_LOG', false );
  define( 'WP_DEBUG_DISPLAY', false );
}

if($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https'){
  $_SERVER['HTTPS'] = 'on';
  $_SERVER['SERVER_PORT'] = 443;
}
