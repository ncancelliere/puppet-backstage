class backstage::install {
  Exec {
    path => ["/opt/torquebox/current/jruby/bin", "/usr/local/bin", "/usr/bin", "/bin", "/sbin"],
  }

  package { "git":
    ensure => present,
  }

  file { "/var/www":
    ensure => directory,
  }

  file { "/var/www/apps":
    ensure => directory,
    require => File["/var/www"],
  }

  exec { "build-backstage":
    cwd => "/var/www/apps",
    command => "su - torquebox &&
                git clone https://github.com/torquebox/backstage.git &&
                cd backstage &&
                jruby -S gem install jruby-openssl &&
                jruby -S bundle install &&
                chown -R torquebox:torquebox /var/www/apps/backstage",
    creates => "/var/www/apps/backstage/bin/backstage",
    logoutput => true,
    timeout => 0,
    require => [Class["torquebox"], Class["backstage::config"], Package["git"], File["/var/www/apps"]],
  }

  exec { "dodeploy-backstage":
    cwd => "/opt/torquebox/current/jboss/standalone/deployments",
    command => "su - torquebox &&
                touch torquebox-backstage-knob.yml.dodeploy",
    creates => "/opt/torquebox/current/jboss/standalone/deployments/torquebox-backstage-knob.yml.deployed",
    logoutput => true,
    timeout => 0,
    require => Exec["build-backstage"],
  }

}
