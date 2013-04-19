class garrstack::repository(
  $openstack_version = 'folsom',
) {
  
  package { 'ubuntu-cloud-keyring':
    ensure => present,
  }
  
  file { 'cloud-apt-archive':
    ensure => present,
    path => '/etc/apt/sources.list.d/cloud-archive.list',
    content => "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/${openstack_version} main",
    notify => Exec["apt-get-update-openstack"],
  }
  
  exec {
    "apt-get-update-openstack":
      command => "/usr/bin/apt-get update",
      require => File['cloud-apt-archive'];
      
    #"apt-get-upgrade-openstack":
    #  command => "/usr/bin/apt-get upgrade",
    #  require => Exec["apt-get-update-openstack"],
  }
  
}

