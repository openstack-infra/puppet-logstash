# This files resources are declared on elasticsearch module
# and cannot be declared on the logstash::elasticsearch
# as it cause duplication error on other tests.
# This is only needed in acceptance tests.
file { '/etc/elasticsearch':
  ensure => directory,
  owner  => 'root',
}

file { '/etc/elasticsearch/templates':
  ensure  => directory,
  owner   => 'root',
  require => File['/etc/elasticsearch'],
}

class { '::logstash': }

class { '::logstash::indexer':
  require => Class['::logstash'],
}

class { '::logstash::elasticsearch':
  require => Class['::logstash'],
}

class { '::logstash::indexer':
  require => Class['::logstash'],
}
