stage { "init": before  => Stage["main"] }

class {'::packstack::prereqs': 
  stage => init, 
}

create_resources(sshkey, hiera('SSH_KEYS', {}))

if hiera('CONFIG_NTP_SERVERS', undef) != undef {
  include '::packstack::chrony'
}

if hiera('CONFIG_CEILOMETER_INSTALL') == 'y' {
  include '::packstack::nova::ceilometer::rabbitmq'
  include '::packstack::nova::ceilometer'
}

include '::packstack::nova'
include '::packstack::nova::common'
include '::packstack::nova::compute'

if hiera('CONFIG_VMWARE_BACKEND') == 'y' {
  # TODO:  manifestdata += ("\n$nova_vcenter_cluster_name = 's'\n"  vmware_clusters[host])
  include '::packstack::nova::compute::vmware'
} elsif hiera('CONFIG_IRONIC_INSTALL') == 'y' {
  include '::packstack::nova::compute::ironic'
} else {
  include '::packstack::nova::compute::libvirt'
}

if hiera('CONFIG_VMWARE_BACKEND') == 'y' and
   hiera('CONFIG_CINDER_INSTAL') == 'y' {
   if 'gluster' in hiera_array('CONFIG_CINDER_BACKEND') {
    include '::packstack::nova::gluster'
   }
   if 'nfs' in hiera_array('CONFIG_CINDER_BACKEND') {
    include '::packstack::nova::nfs'
   }
}

if hiera('CONFIG_VMWARE_BACKEND') == 'y' and
   hiera('CONFIG_CINDER_INSTAL') == 'y' {
   if 'gluster' in hiera_array('CONFIG_CINDER_BACKEND') {
    include '::packstack::nova::gluster'
   }
   if 'nfs' in hiera_array('CONFIG_CINDER_BACKEND') {
    include '::packstack::nova::nfs'
   }
}

if hiera('CONFIG_NEUTRON_INSTALL') == 'y' {
# TODO: implement the following logic in puppet:
#            if host not in network_hosts:
#                manifestdata += getManifestTemplate('nova_compute_flat')
}

if hiera('CONFIG_NEUTRON_INSTALL') == 'y' {
  include '::packstack::nova::neutron'
  include '::packstack::neutron::rabbitmq'
  case hiera('CONFIG_NEUTRON_L2_AGENT') {
    'openvswitch': { include '::packstack::neutron::ovs_agent' }
    '':            { include '::packstack::neutron::lb_agent' }
    default:       { include '::packstack::neutron::ovs_agent' }
  }
  include '::packstack::neutron::bridge'

  if 'sriovnicswitch' in hiera_array('CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS') and
     hiera ('CONFIG_NEUTRON_L2_AGENT') == 'openvswitch' {
    include '::packstack::neutron::sriov'
  }
} else {
  include '::packstack::nova::network::libvirt'
  # TODO:       
  # in multihost mode each compute host runs nova-api-metadata
  #      if multihost and host != api_host and host in compute_hosts:
  #          manifestdata += getManifestTemplate("nova_metadata")
}

if hiera('CONFIG_NAGIOS_INSTALL') == 'y' {
  include '::packstack::nagios::nrpe'
}