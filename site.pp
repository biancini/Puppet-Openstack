###################################################
# Sezione Openstack
###################################################

####### shared variables ##################
$password               = 'ciaoStack'
# assumes that eth0 is the public interface
$public_interface        = 'eth0'
$private_interface       = 'eth1'
# credentials
$admin_email             = 'root@localhost'
$keystone_admin_token    = 'ciaostack_token'
$rabbit_user             = 'openstack_rabbit_user'
$fixed_network_range     = '10.0.1.0/24'
$floating_network_range  = '10.0.0.176/28'
$horizon_secret_key      = 'ciaostack_key'
# switch this to true to have all service log at verbose
$verbose                 = true
$auto_assign_floating_ip = false

# multi-node specific parameters
$controller_node_address  = '10.0.0.170' 
$controller_node_public   = $controller_node_address
$controller_node_internal = $controller_node_address
$sql_connection           = "mysql://nova:${password}@${controller_node_internal}/nova"
$cinder_sql_connection    = "mysql://cinder:${password}@${controller_node_internal}/cinder?charset=utf8"
$multi_host               = true
$network_manager          = 'nova.network.manager.VlanManager'
#### end shared variables #################

node 'idp-openstack' {
  stage { 'first':
    before => Stage['main'],
  }

  class { 'openstack::repository':
    stage => first,
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
}

node 'idp-compute1', 'idp-compute2' {
  stage { 'first':
    before => Stage['main'],
  }

  class { 'openstack::repository':
    stage => first,
  }

  class { 'openstack::compute':
    public_interface        => $public_interface,
    private_interface       => $private_interface,
    internal_address        => $ipaddress_eth0,
    libvirt_type            => 'qemu',
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
}

