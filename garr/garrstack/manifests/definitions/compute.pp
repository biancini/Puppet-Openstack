define garrstack::compute(
  $public_interface = undef,
  $private_interface = undef,
  $libvirt_type = undef,
  $fixed_network_range = undef,
  $multi_host = undef,
  $sql_connection = undef,
  $password = undef,
  $controller_node_internal = undef,
  $rabbit_user = undef,
  $controller_node_public = undef,
  $verbose = undef,
  $cinder_sql_connection = undef,
) {

  stage { 'first': } -> Stage['main']

  class {
    'openstack::repository':
      stage => first;
 
    'garrstack::usergroups':
      stage => first;
  }

  class { 'openstack::compute':
    public_interface        => $public_interface,
    private_interface       => $private_interface,
    internal_address        => $ipaddress_eth0,
    libvirt_type            => $libvirt_type,
    fixed_range             => $fixed_network_range,
    network_manager         => $network_manager,
    multi_host              => $multi_host,
    sql_connection          => $sql_connection,
    nova_user_password      => $password,
    rabbit_host             => $controller_node_internal,
    rabbit_password         => $password,
    rabbit_user             => $rabbit_user,
    glance_api_servers      => "${controller_node_internal}:9292",
    vncproxy_host           => $controller_node_public,
    vnc_enabled             => true,
    verbose                 => $verbose,
    manage_volumes          => true,
    nova_volume             => 'nova-volumes',
    cinder_sql_connection   => $cinder_sql_connection,
    migration_support       => true,
    vncserver_listen        => '0.0.0.0',
  }

  class { 'garrstack::configs':
    require => Class['openstack::compute'],
    notify => Exec['start-scsi'],
  }
  
  exec { 'start-scsi':
    command     => 'service open-iscsi restart',
    path        => ['/usr/bin', '/usr/sbin'],
    user        => 'root',
    refreshonly => true,
  }

}
