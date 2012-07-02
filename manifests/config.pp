class backstage::config {  

  file { "/opt/torquebox/current/jboss/standalone/deployments/torquebox-backstage-knob.yml":
    ensure => present,
    source => "puppet:///modules/backstage/torquebox-backstage-knob.yml",
    owner => "torquebox",
    group => "torquebox",
    mode => 644,
    require => Class["torquebox"],
  }
  
}