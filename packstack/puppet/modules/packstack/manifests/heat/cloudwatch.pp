class packstack::heat::cloudwatch ()
{
    class { '::heat::api_cloudwatch':
      workers => hiera('CONFIG_SERVICE_WORKERS'),
    }
}
