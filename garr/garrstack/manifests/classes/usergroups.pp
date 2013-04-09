class garrstack::usergroups {
  file_line {
    'libvirt-qemu-usr':
      path => '/etc/passwd',
      line => "libvirt-qemu:x:111:117:Libvirt Qemu,,,:/var/lib/libvirt:/bin/false",
      match => 'libvirt-qemu';
    
    'libvirt-dnsmasq-usr':
      path => '/etc/passwd',
      line => "libvirt-dnsmasq:x:112:118:Libvirt Dnsmasq,,,:/var/lib/libvirt/dnsmasq:/bin/false",
      match => 'libvirt-dnsmasq';
      
    'nova-usr':
      path => '/etc/passwd',
      line => "nova:x:113:119::/var/lib/nova:/bin/false",
      match => 'nova';

    'cinder-usr':
      path => '/etc/passwd',
      line => "cinder:x:114:120::/var/lib/cinder:/bin/sh",
      match => 'cinder'; 
  }
  
  file_line {
    'kvm-grp':
      path => '/etc/group',
      line => "kvm:x:117:",
      match => 'kvm';
    
    'libvirtd-grp':
      path => '/etc/group',
      line => "libvirtd:x:118:nova",
      match => 'libvirtd';
	
	  'nova-grp':
      path => '/etc/group',
      line => "nova:x:119:cinder",
      match => 'nova';
  
    'cinder-grp':
      path => '/etc/group',
      line => "cinder:x:120:nova",
      match => 'cinder';
  }
}
