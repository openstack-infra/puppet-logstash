# logstash::params
class logstash::params(
) {
  case $::lsbrelease {
    'xenial': {
      $jre_package = 'openjdk-8-jre-headless'
    }
    default: {
      $jre_package = 'openjdk-7-jre-headless'
    }
  }
}
