Puppet modules to install Shibboleth IdP and SP on linux
========================================================

This project contains pupped modules for different pieces of software, in particular
it is intended to provide the required installation steps for Internet2 implementations
of Shibboleth:

 * Shibboleth IdP
 * Shibboleth SP

The module has been developed and tested on Debian linux systems.

Configuration of the puppet master
==================================
The modules developed can be installed on a Puppet Agent running puppet 3.0.2.
The steps to hava a puppet master installed correctly are:

 * install debian squeezy (or wheezy) on the target machine
   from the installation parmeters, choose ONLY "standard system utilities" and "ssh server" to minimize
   the number of packages to be installed on the targed machine

 * on the installed machine configure the network and the name resolution so that the machine reachable
   with its FQDN (as returned by hostname -f).

 * on the installed machine install puppet 3.0.2 by executing:
   wget http://apt.puppetlabs.com/puppetlabs-release-squeeze.deb
   dpkg -i puppetlabs-release-squeeze.deb
   apt-get update
   apt-get install puppetmaster / apt-get install puppet
   apt-get dist-upgrade

 * on the installed machine change /etc/puppet/puppet.conf by adding the following lines after \[master\]:
   ```
   [master]
   dns_alt_names=puppet
   manifest=$confdir/manifests/site.pp
   modulepath=$confdir/modules
   reports=store,tagmail

   ```

 * all modules in the garr folder of this GitHub project must be copied under /etc/puppet/modules

 * the apache and mysql modules must be installed from puppetlabs repository with the commands:
   puppet module install puppetlabs/apache
   puppet module install puppetlabas/mysql

 * modify the /etc/puppet/manifests/site.pp with the required node configurations

 * start puppet agent daemon with:
   service puppetagent start



Tests
=====
The modules have been developed for Debian (version squeezy and wheezy) and have been tested on an environment using the
Debian squeezy version of linux.

To test the installation of Shibboleth IdP, for instance, the following steps have been executed:

 * install debian squeezy (or wheezy) on the target machine
   from the installation parmeters, choose ONLY "standard system utilities" and "ssh server" to minimize
   the number of packages to be installed on the targed machine

 * on the installed machine configure the network and the name resolution so that the target machine is
   able to ping the puppet master with all the puppet recipes installed

 * on the target machine execute:
   apt-get install puppet puppet-common augeas-tools augeas-lenses

 * on the target machine change /etc/puppet/puppet.conf by removing all lines after \[master\] \(included\) and
   specifying the following additional lines:
   ```
   [agent]
   server=puppetmaster.example.com
   reprot=true
   pluginsync=true
   runinterval=1800
   ```
 * on the target machine change /etc/default/puppet specifying ``START=yes`` and then execute ``service puppet start``

 * on the master accept the certificate from the target machine using for example the following commands, if the
   puppet agent hostname is puppetagent.example.com:
   ```
   # puppet cert list 
   # puppetca cert sign "puppetagent.example.com"
   ```

 * on the puppet master add in the file ``site.pp`` a node definition for the puppet client to be installed with the 
   configuration example provided below.

 * on the puppet master create a key and a cert to be used as HTTPS certificates for the new IdP to be installed, for
   example the following commands could be executed (if the puppet agent hostname is puppetagent.example.com):
   ```
   cd /etc/puppet/modules/shib2idp/files/certs
   openssl req -new -x509 -nodes -out puppetagent-cert-server.pem -keyout puppetagent-key-server.pem -days 3650 -subj '/CN=puppetagent.example.com'
   ```

 * on the puppet master create a TOU file to be used by uApprove
   this file must be contained in the folder ``/etc/puppet/modules/shib2idp/files/tou`` and must have name ``puppetagent-tou.html``,
   if the puppet agent hostname is puppetagent.example.com.
   
 * on the puppet master place your Logo file to be used by IdP Login Page 
 	this file must be conteined in the folder ``/etc/puppet/modules/shib2idp/files/stili`` and must have name ``puppetagent-logo.jpg``, 
 	if the puppet agent hostname is puppetagent.example.com.

 * on the puppet master place your CSS file to be used by IdP Login Page 
 	this file must be conteined in the folder ``/etc/puppet/modules/shib2idp/files/stili`` and must have name ``puppetagent-login.css``, 
 	if the puppet agent hostname is puppetagent.example.com.
 	
 * on the puppet master place your Logo file to be used by IdP Metadata
 	this file must be conteined in the folder ``/etc/puppet/modules/shib2idp/files/stili`` and must have name ``puppetagent-logo16x16_it.png``, 
 	if the puppet agent hostname is puppetagent.example.com.
 	
 * on the puppet master place your Logo file to be used by IdP Metadata 
 	this file must be conteined in the folder ``/etc/puppet/modules/shib2idp/files/stili`` and must have name ``puppetagent-logo80x60_it.png``, 
 	if the puppet agent hostname is puppetagent.example.com.
 	
 * on the puppet master place your Logo file to be used by IdP Metadata
 	this file must be conteined in the folder ``/etc/puppet/modules/shib2idp/files/stili`` and must have name ``puppetagent-logo16x16_en.png``, 
 	if the puppet agent hostname is puppetagent.example.com.
 	
 * on the puppet master place your Logo file to be used by IdP Metadata 
 	this file must be conteined in the folder ``/etc/puppet/modules/shib2idp/files/stili`` and must have name ``puppetagent-logo80x60_en.png``, 
 	if the puppet agent hostname is puppetagent.example.com.

 * on the target machine restart the puppet service.

Examples
========

Shibboleth IdP
--------------
To create a machine with the Internet2 implementation of a Shibboleth IdP the following actions
are requested. Below an example configuration that should be put into the site.pp file on the Puppet Master:

```

node 'agenthostname' {
  class { 'shib2idp::iptables':
    iptables_enable_network => '192.168.56.0/24',
  }

  shib2idp::instance { "${hostname}-idp":
    metadata_information => {
       'en' => {
          'orgDisplayName' => 'Test IdP for IdP in the cloud project',
          'communityDesc' => 'GARR Research &amp; Development',
          'orgUrl' => 'http://www.garr.it/',
          'privacyPage' => 'http://www.garr.it/',
          'nameOrg' => 'Consortium GARR',
          'idpInfoUrl' => 'http://puppetclient.example.com/info.html',
          'url_LogoOrg-16x16' => 'https://puppetclient.example.com/idp/images/logoEnte-16x16_en.png',
          'url_LogoOrg-80x60' => 'https://puppetclient.example.com/idp/images/logoEnte-80x60_en.png',
       }, 
      
       'it' => {
          'orgDisplayName' => 'Test IdP for IdP in the cloud project',
          'communityDesc' => 'GARR Research &amp; Development',
          'orgUrl' => 'http://www.garr.it/',
          'privacyPage' => 'http://www.garr.it/',
          'nameOrg' => 'Consortium GARR',
          'idpInfoUrl' => 'http://puppetclient.example.com/info.html',
          'url_LogoOrg-16x16' => 'https://puppetclient.example.com/idp/images/logoEnte-16x16_it.png',
          'url_LogoOrg-80x60' => 'https://puppetclient.example.com/idp/images/logoEnte-80x60_it.png',
       },
          
       'technicalEmail' => 'support@puppetclient.example.com',
    },
    configure_admin => true,
    tomcat_admin_password => 'adminpassword',
    tomcat_manager_password => 'managerpassword',
    shibbolethversion => '2.3.8',
    install_uapprove => true,
    idpfqdn => 'idp.example.org',
    keystorepassword => 'puppetpassword',
    mailto => 'support@email.com',
    install_ldap => true,
    domain_name => 'example.com',
    basedn => 'dc=example,dc=com',
    rootdn => 'cn=admin',
    rootpw => 'ldappassword',
    ldap_host => undef,
    ldap_use_ssl => undef,
    ldap_use_tls => undef,
    logserver => undef,
    nagiosserver => undef,
    sambadomain => 'WORKGROUP',
  }
}
```

The configuration of the IdP begins with an optional configuration of iptables on the agent machine.
The iptables class permits to configure a software firewall on the Puppet agent machine using iptables.
This class ensures that the iptables package is installed on the system and then configures
some rules to filter traffic.

The configuration pushed on each Puppet agent is a configuration which closes all ports except
for ICMP traffic, port 80, 443, 8080 and 8443 (used by Tomcat and so the IdP to work properly)
and port 22 for ssh.
Port 22, in particular, can be configured to be open only on certain networks, specified with
the $iptables_enable_network param to this class.

The iptables class has the following parameters:
 * **$iptables_enable_network** => The network on which ssh should be accessible.
   If set to '192.168.0.0/24', for example, the ssh port will be accessible only by hosts
   with IP ranging from 192.168.0.1 to 192.168.0.254.
   If not set (or set to '') ssh port will be accessible by every network and every host.

After that the example provided installs and configures the Shibboleth IdP on the Puppet agent machine.
At first it installs the prerequisites needed to the IdP to be installed.
Then downloads and installs the IdP Package from Internet2 Shibbolet.

The parameters that can be specified to describe a Shibboleth IdP instance are the following:
 * **$configure_admin** => This param permits to specify if the Tomcat administration interface
   has to be installed on the Tomcat instance or not.
   If set to true the administration interface is installed and will be accessible on the port
   8080 of the Puppet agent machine.
 * **$tomcat_admin_password** => If the Tomcat administration interface is going to beinstalled this
   parameter permits to specify the password for the 'admin' user used by tomcat to access
   the administration interface. 
 * **$tomcat_manager_password** => If the Tomcat administration interface is going to beinstalled this
   parameter permits to specify the password for the 'manager' user used by tomcat to access
   the administration interface.
 * **$shibbolethversion** => This parameter permits to specify the version of Shibboleth IdP to be downloaded
   from the Internet2 repositories. By default the 2.3.3 version will be downloaded.
 * **$idpfqdn** => This parameters must contain the fully qualified domain name of the IdP. This name must
   be the exact name used by client users to access the machine over the Internet. This FQDN, in fact,
   will be used to determine the CN of the certificate used for HTTPS. If the name is not identical
   with the server name specified by the client, the client's browser will raise a security
   exception. 
 * **$keystorepassword** => This parameter permits to specify the keystore password used to protect the
   keystore file on the IdP server.
 * **$mailto** => The email address to be notified when the certificate used for HTTPS is about to expire.
   If no email address is specified, no mail warning will be sent.

Shibboleth SP
-------------
Create a machine with the Internet2 implementation of a Shibboleth SP:
```
```
Example to be described.
