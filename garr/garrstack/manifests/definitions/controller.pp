define garrstack::controller(
  $controller_node_public = undef,
  $public_interface = undef,
  $private_interface = undef,
  $controller_node_internal = undef,
  $floating_network_range = undef,
  $fixed_network_range = undef,
  $multi_host = undef,
  $verbose = undef,
  $auto_assign_floating_ip = undef,
  $password = undef,
  $admin_email = undef,
  $keystone_admin_token = undef,
  $rabbit_user = undef,
  $horizon_secret_key = undef,
) {

  stage { 'first': } -> Stage['main'] -> stage { 'last': }

  class {
    'openstack::repository':
      stage => first;
 
    'garrstack::usergroups':
      stage => first;
  }

  # deploy a script that can be used to test nova
  class { 'openstack::test_file': }

  class { 'openstack::controller':
  #class { 'openstack::all':
    public_address          => $controller_node_public,
    public_interface        => $public_interface,
    private_interface       => $private_interface,
    internal_address        => $controller_node_internal,
    floating_range          => $floating_network_range,
    fixed_range             => $fixed_network_range,
    multi_host              => $multi_host,
    network_manager         => $network_manager,
    verbose                 => $verbose,
    auto_assign_floating_ip => $auto_assign_floating_ip,
    mysql_root_password     => $password,
    admin_email             => $admin_email,
    admin_password          => $password,
    keystone_db_password    => $password,
    keystone_admin_token    => $keystone_admin_token,
    glance_db_password      => $password,
    glance_user_password    => $password,
    nova_db_password        => $password,
    nova_user_password      => $password,
    rabbit_host             => $controller_node_internal,
    rabbit_password         => $password,
    rabbit_user             => $rabbit_user,
    secret_key              => $horizon_secret_key,
    cinder_user_password    => $password,
    cinder_db_password      => $password,
    # parameters added for all installation instead of controller
    #libvirt_type            => 'qemu',
    #vncproxy_host           => $controller_node_public,
    #vnc_enabled             => true,
    #manage_volumes          => true,
    #nova_volume             => 'nova-volumes',
    #migration_support       => true,
    #vncserver_listen        => '0.0.0.0',
  }
  
  class { 'openstack::auth_file':
    admin_password          => $password,
    keystone_admin_token    => $keystone_admin_token,
    controller_node         => $controller_node_internal,
  }
  
  class { 'garrstack::configs':
    stage => last;
  }

}
