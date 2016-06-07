class packstack::neutron::vpnaas ()
{
    class { '::neutron::services::fwaas':
      enabled => true,
      driver  => 'neutron_fwaas.services.firewall.drivers.linux.iptables_fwaas.IptablesFwaasDriver',
    }
}
