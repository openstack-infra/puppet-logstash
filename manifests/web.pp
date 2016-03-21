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
  $discover_nodes      = ['localhost:9200'],
  $frontend            = 'internal',
  $proxy_elasticsearch = false,
  $serveradmin         = "webmaster@${::fqdn}",
  $vhost_name          = $::fqdn,
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

  case $frontend {
    'internal': {
      fail('This stopped working when we moved to Kibana3 and there is no analog in logstash 2.0. Use kibana.')
    }

    'kibana': {
      class { '::kibana':
        version                 => 'js',
        discover_nodes          => $discover_nodes,
        js_elasticsearch_prefix => '/elasticsearch/',
        js_elasticsearch_url    => "http://${discover_nodes[0]}",
      }
    }

    default: {
      fail("Unknown frontend to logstash: ${frontend}.")
    }
  }
}
