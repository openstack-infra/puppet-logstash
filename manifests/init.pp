# Copyright 2013 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# = Class: Logstash
#
# Class to install common logstash items.
#
class logstash {
  include ::logrotate

  archive { '/tmp/logstash-2.4.1_all.deb':
    source        => 'https://download.elastic.co/logstash/logstash/packages/debian/logstash-2.4.1_all.deb',
    extract       => false,
    checksum      => '7ba3b174a3ef48a7d0945d9b5c7f12c5005abb47',
    checksum_type => 'sha1',
  }

  if ! defined(Package['openjdk-7-jre-headless']) {
    package { 'openjdk-7-jre-headless':
      ensure => present,
    }
  }

  package { 'logstash':
    ensure   => latest,
    source   => '/tmp/logstash-2.4.1_all.deb',
    provider => 'dpkg',
    require  => [
      Package['logrotate'],
      Package['openjdk-7-jre-headless'],
      Archive['/tmp/logstash-2.4.1_all.deb'],
    ]
  }
}
