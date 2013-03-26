class garrstack::usergroups {
  user {
    #libvirt-qemu:x:111:117:Libvirt Qemu,,,:/var/lib/libvirt:/bin/false
    'garr-libvirt-qemu':
      name    => 'libvirt-qemu',
      uid     => 111,
      gid     => 117,
      comment => "Libvirt Qemu,,,",
      home    => "/var/lib/libvirt",
      shell   => "/bin/false",
      ensure  => present;
      
    #libvirt-dnsmasq:x:112:118:Libvirt Dnsmasq,,,:/var/lib/libvirt/dnsmasq:/bin/false
    'garr-libvirt-dnsmasq':
      name    => 'libvirt-dnsmasq',
      uid     => 112,
      gid     => 118,
      comment => "Libvirt Dnsmasq,,,",
      home    => "/var/lib/libvirt/dnsmasq",
      shell   => "/bin/false",
      ensure  => present;

    #nova:x:113:119::/var/lib/nova:/bin/false
    'garr-nova':
      name    => 'nova',
      uid     => 113,
      gid     => 119,
      comment => "",
      home    => "/var/lib/nova",
      shell   => "/bin/false",
      ensure  => present;
  
    #cinder:x:114:120::/var/lib/cinder:/bin/false
    'garr-cinder':
      name    => 'cinder',
      uid     => 114,
      gid     => 120,
      comment => "",
      home    => "/var/lib/cinder",
      shell   => "/bin/false",
      ensure  => present;
  }

	group {
	  #kvm:x:117:
	  'garr-kvm':
	    name    => 'kvm',
	    gid     => 117,
	    ensure  => present;
	
    #libvirtd:x:118:nova
    'garr-libvirtd':
      name    => 'libvirtd',
      gid     => 118,
      members => ['nova'],
      ensure  => present;
  
    #nova:x:119:
    'garr-nova':
      name    => 'nova',
      gid     => 119,
      ensure  => present;
   
    #cinder:x:120:
    'garr-cinder':
      name    => 'cinder',
      gid     => 120,
      ensure  => present;
  }
}