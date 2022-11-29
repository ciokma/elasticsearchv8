class elasticsearch {

  class { 'java':
    distribution => jre,
  }
  
  yumrepo { 'elasticsearch':
    ensure     => 'present',
    descr      => 'Elasticsearch repository for 8.x packages',
    gpgcheck   => '1',
    enabled    => '1',
    gpgkey     => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
    baseurl    => 'https://artifacts.elastic.co/packages/8.x/yum',
  }

  package {'elasticsearch':
    ensure => installed,
    require => Class['java']
  }

  service {'elasticsearch':
    ensure => running,
    enable => true,
    require => Package['elasticsearch']
  }


}
