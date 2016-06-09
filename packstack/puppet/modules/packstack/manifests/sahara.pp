class packstack::sahara ()
{
    class { '::sahara::service::api':
      api_workers => hiera('CONFIG_SERVICE_WORKERS')
    }

    class { '::sahara::service::engine': }
}
