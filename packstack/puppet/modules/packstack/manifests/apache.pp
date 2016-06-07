class packstack::apache ()
{
    include ::apache

    if hiera('CONFIG_HORIZON_SSL')  == 'y' {
      ensure_packages(['mod_ssl'], {'ensure' => 'present'})
      Package['mod_ssl'] -> Class['::apache']
    }
    if hiera('CONFIG_HORIZON_SSL')  == 'y' {
      apache::listen { '443': }
    }

    apache::listen { '5000': }
    apache::listen { '35357': }

    if hiera('CONFIG_CEILOMETER_INSTALL') == 'y' {
      if hiera('CONFIG_CEILOMETER_SERVICE_NAME') == 'httpd' {
        apache::listen { '8777': }
      }
    }

    if hiera('CONFIG_AODH_INSTALL') == 'y' {
      apache::listen { '8042': }
    }

    if hiera('CONFIG_GNOCCHI_INSTALL') == 'y' {
      apache::listen { '8041': }
    }
}

