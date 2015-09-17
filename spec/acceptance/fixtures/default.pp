class { '::logstash': }

class { '::logstash::agent':
  require => Class['::logstash'],
}
class { '::logstash::elasticsearch':
  require => Class['::logstash'],
}

class { '::logstash::indexer':
  require => Class['::logstash'],
}

class { '::logstash::redis':
  require => Class['::logstash'],
}
