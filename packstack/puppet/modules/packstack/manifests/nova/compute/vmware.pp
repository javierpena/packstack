class packstack::nova::compute::vmware ()
{
    class { '::nova::compute::vmware':
      host_ip       => hiera('CONFIG_VCENTER_HOST'),
      host_username => hiera('CONFIG_VCENTER_USER'),
      host_password => hiera('CONFIG_VCENTER_PASSWORD'),
      # TODO: this requires something to be changed in compute.pp
      cluster_name  => $nova_vcenter_cluster_name,
    }
}
