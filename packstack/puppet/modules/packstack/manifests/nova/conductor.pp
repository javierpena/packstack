class packstack::nova::conductor ()
{
    class { '::nova::conductor':
      enabled => true,
    }
}
