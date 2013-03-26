class garrstack::usergroups {
  #libvirt-qemu:x:111:117:Libvirt Qemu,,,:/var/lib/libvirt:/bin/false
  user { 'libvirt-qemu':
    uid     => 111,
    gid     => 117,
    comment => "Libvirt Qemu,,,",
    home    => "/var/lib/libvirt",
    shell   => "/bin/false",
  }
  
  #libvirt-dnsmasq:x:112:118:Libvirt Dnsmasq,,,:/var/lib/libvirt/dnsmasq:/bin/false
  user { 'libvirt-dnsmasq':
    uid     => 112,
    gid     => 118,
    comment => "Libvirt Dnsmasq,,,",
    home    => "/var/lib/libvirt/dnsmasq",
    shell   => "/bin/false",
  }

  #nova:x:113:119::/var/lib/nova:/bin/false
  user { 'nova':
    uid     => 113,
    gid     => 119,
    comment => "",
    home    => "/var/lib/nova",
    shell   => "/bin/false",
  }
  
  #cinder:x:114:120::/var/lib/cinder:/bin/false
  user { 'cinder':
    uid     => 114,
    gid     => 120,
    comment => "",
    home    => "/var/lib/cinder",
    shell   => "/bin/false",
  }

  #da aggiungere in /etc/group
  #kvm:x:117:
	group { 'kvm':
	 gid     => 117,
	}
	
  #libvirtd:x:118:nova
  group { 'libvirtd':
   gid     => 118,
  }
  
  #nova:x:119:
  group { 'nova':
   gid     => 119,
  }
  
  #cinder:x:120:
  group { 'cinder':
   gid     => 120,
  }
}