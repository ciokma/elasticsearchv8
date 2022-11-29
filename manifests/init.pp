class elasticsearchv8 {

  class { 'java':
    distribution => jre,
    #before => Class['::elasticsearch'],  Class['::logstash']],
  }
  
  yumrepo { 'elasticsearch':
    ensure     => 'present',
    descr      => 'Elasticsearch repository for 8.x packages',
    gpgcheck   => '1',
    enabled    => '1',
    gpgkey     => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
    baseurl    => 'https://artifacts.elastic.co/packages/8.x/yum',
  }
  ->
  package {'elasticsearch':
    ensure => installed,
    require => Class['java']
  }
  ->
  #elasticsearch.yaml configuration
  file {'/etc/elasticsearch/elasticsearch.yml':
    ensure => file,
    mode   => '0660',
    owner  => 'root',
    group  => 'elasticsearch',
    source => 'puppet:///modules/elasticsearchv8/elasticsearch.yml',
  }
  ->
  service {'elasticsearch':
    ensure => running,
    enable => true,
    require => Package['elasticsearch']
  }
  ->
  #logstash
  package {'logstash':
    ensure  => installed,
    require => Package['elasticsearch'],
  }
  ->
  file {'/etc/logstash/conf.d/central.conf':
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/elasticsearchv8/central.conf',
  }

  ~>
  service {'logstash':
    ensure => running,
    enable => true,
  }
  ->
  #kibana
  package {'kibana':
    ensure  => installed,
    require => Package['elasticsearch'],
  }
  ->
  user {'kibana':
    ensure => present,
    shell  => '/bin/false',
    before => [File['kibana.service'], Service['kibana']],
  }
  ->
  file {'kibana.service':
    path   => '/usr/lib/systemd/system/kibana.service',
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/elasticsearchv8/kibana.service',
  }
  ~>
  service {'kibana':
    ensure => running,
    enable => true,
  }

}
