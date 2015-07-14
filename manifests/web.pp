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
# = Class: logstash::web
#
# Class to run logstash web front end
#
# == Parameters
#
# [*vhost_name*]
#   String. FQDN of the web listener
#   Default: $::fqdn
#
# [*serveradmin*]
#   String. Email address of the administator
#   Default: webserver@${::fqdn}
#
# [*frontend*]
#   String. Which kind of web frontend to use
#   Default: internal
#   Valid Values: 'internal', 'kibana'
#
# [*discover_nodes*]
#   Array of strings. Nodes to connect to by default (kibana only)
#   Default: ['localhost:9200']
#
# [*proxy_elasticsearch*]
#   Boolean. Enables using apache mod_proxy to proxy reqs to ES (kibana only)
#   Default: false
#
class logstash::web (
  $vhost_name = $::fqdn,
  $serveradmin = "webmaster@${::fqdn}",
  $frontend = 'internal',
  $discover_nodes = ['localhost:9200'],
  $proxy_elasticsearch = false
) {
  include ::httpd
  httpd_mod { 'rewrite':
    ensure => present,
  }
  httpd_mod { 'proxy':
    ensure => present,
  }
  httpd_mod { 'proxy_http':
    ensure => present,
  }

  include logstash

  case $frontend {
    'internal': {
      file { '/etc/init/logstash-web.conf':
        ensure  => present,
        source  => 'puppet:///modules/logstash/logstash-web.conf',
        replace => true,
        owner   => 'root',
      }

      service { 'logstash-web':
        ensure    => running,
        enable    => true,
        require   => [
          Class['logstash'],
          File['/etc/init/logstash-web.conf'],
        ],
      }

      $vhost = 'logstash/logstash.vhost.erb'
    }

    'kibana': {
      class { 'kibana':
        discover_nodes => $discover_nodes,
      }
      $vhost = 'logstash/kibana.vhost.erb'
    }

    default: {
      fail("Unknown frontend to logstash: ${frontend}.")
    }
  }

  ::httpd::vhost { $vhost_name:
    port       => 80,
    docroot    => 'MEANINGLESS ARGUMENT',
    priority   => '50',
    template   => $vhost,
    vhost_name => $vhost_name,
  }
}
