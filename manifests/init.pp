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
  archive { '/tmp/logstash_2.0.0-1_all.deb':
    source        => 'https://download.elastic.co/logstash/logstash/packages/debian/logstash_2.0.0-1_all.deb',
    extract       => false,
    checksum      => '094b18c77d7c959c1203012983337d5249922290',
    checksum_type => 'sha1',
  }

  if ! defined(Package['openjdk-7-jre-headless']) {
    package { 'openjdk-7-jre-headless':
      ensure => present,
    }
  }

  package { 'logstash':
    ensure   => latest,
    source   => '/tmp/logstash_2.0.0-1_all.deb',
    provider => 'dpkg',
    require  => [
      Package['openjdk-7-jre-headless'],
      Archive['/tmp/logstash_2.0.0-1_all.deb'],
    ]
  }
}
