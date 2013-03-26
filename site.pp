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
$libvirt_type             = 'qemu'
#### end shared variables #################

node 'idp-openstack' {
  garrstack::controller { "${hostname}":
  #garrstack::all { "${hostname}":
    controller_node_public      => $controller_node_public,
    public_interface            => $public_interface,
    private_interface           => $private_interface,
    controller_node_internal    => $controller_node_internal,
    floating_network_range      => $floating_network_range,
    fixed_network_range         => $fixed_network_range,
    multi_host                  => $multi_host,
    verbose                     => $verbose,
    auto_assign_floating_ip     => $auto_assign_floating_ip,
    password                    => $password,
    admin_email                 => $admin_email,
    keystone_admin_token        => $keystone_admin_token,
    rabbit_user                 => $rabbit_user,
    horizon_secret_key          => $horizon_secret_key,
    # parameters added for all installation instead of controller
    #libvirt_type            => $libvirt_type,
  }
}

node 'idp-compute1', 'idp-compute2' {
  garrstack::compute { "${hostname}":
    public_interface            => $public_interface,
    private_interface           => $private_interface,
    libvirt_type                => $libvirt_type,
    fixed_network_range         => $fixed_network_range,
    multi_host                  => $multi_host,
    sql_connection              => $sql_connection,
    password                    => $password,
    controller_node_internal    => $controller_node_internal,
    rabbit_user                 => $rabbit_user,
    controller_node_public      => $controller_node_public,
    verbose                     => $verbose,
    cinder_sql_connection       => $cinder_sql_connection,
  }
}

