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
# = Class: logstash::indexer
#
# Class to install logstash indexer
#
# == Parameters
#
# [*conf_template*]
#   String. (deprecated) Path to indexer config template.
#   Default: undef
# [*input_template*]
#   String. Path to indexer input config template.
#   Default: 'logstash/input.conf.erb'
# [*output_template*]
#   String. Path to indexer output config template.
#   Default: 'logstash/output.conf.erb'
class logstash::indexer (
  $conf_template   = undef,
  $input_template  = 'logstash/input.conf.erb',
  $output_template = 'logstash/output.conf.erb',
  $enable_mqtt = false,
  $mqtt_hostname = 'firehose.openstack.org',
  $mqtt_port = 8883,
  $mqtt_topic = "logstash/${servername}",
  $mqtt_username = 'infra',
  $mqtt_password = undef,
  $mqtt_certfile_contents = undef,
  $mqtt_key_file_contents = undef,
  $mqtt_ca_cert_contents = undef,
) {
  include ::logstash

  if $conf_template != undef {
    notify { 'Using $conf_template is deprecated, please switch to $input_template, $output_template and ::logstash::filter defines.': }

    file { '/etc/logstash/conf.d/indexer.conf':
      ensure  => present,
      content => template($conf_template),
      replace => true,
      owner   => 'logstash',
      group   => 'logstash',
      mode    => '0644',
      require => Class['logstash'],
      notify  => Service['logstash'],
    }
  } else {
    file { '/etc/logstash/conf.d/indexer.conf':
      ensure => absent,
    }

    file { '/etc/logstash/conf.d/00-input.conf':
      ensure  => present,
      content => template($input_template),
      replace => true,
      owner   => 'logstash',
      group   => 'logstash',
      mode    => '0644',
      require => Class['logstash'],
      notify  => Service['logstash'],
    }

    file { '/etc/logstash/conf.d/99-output.conf':
      ensure  => present,
      content => template($output_template),
      replace => true,
      owner   => 'logstash',
      group   => 'logstash',
      mode    => '0644',
      require => Class['logstash'],
      notify  => Service['logstash'],
    }
  }

  file { '/etc/default/logstash':
    ensure  => present,
    source  => 'puppet:///modules/logstash/logstash.default',
    replace => true,
    owner   => 'logstash',
    group   => 'logstash',
    mode    => '0644',
    require => Class['logstash'],
  }
  if $enable_mqtt {
    exec {'install_mqtt_plugin':
      command => '/opt/logstash/bin/plugin install logstash-output-mqtt',
      before  => Service['logstash']
    }

    if $mqtt_certfile_contents != undef {
      file { '/etc/logstash/mqtt_cert.pem.crt':
        ensure  => present,
        content => $mqtt_certfile_contents,
        replace => true,
        owner   => 'logstash',
        group   => 'logstash',
        mode    => '0600',
        before  => Service['logstash']
      }
    }

    if $mqtt_key_file_contents != undef {
      file { '/etc/logstash/mqtt_private.pem.key':
        ensure  => present,
        content => $mqtt_key_file_contents,
        replace => true,
        owner   => 'logstash',
        group   => 'logstash',
        mode    => '0600',
        before  => Service['logstash']
      }
    }

    file { '/etc/logstash/mqtt-root-CA.pem.crt':
      ensure  => present,
      content => $mqtt_ca_cert_contents,
      replace => true,
      owner   => 'logstash',
      group   => 'logstash',
      mode    => '0600',
      before  => Service['logstash']
    }
  }
  service { 'logstash':
    ensure    => running,
    enable    => true,
    subscribe => [
      File['/etc/default/logstash'],
    ],
    require   => Class['logstash'],
  }
}
